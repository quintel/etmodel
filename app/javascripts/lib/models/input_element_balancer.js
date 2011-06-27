(function (window) {

  /**
   * Creates a balancer instance.
   *
   * Terminology:
   *
   *    master:
   *
   *       When the user begins to alter a slider, this slider is
   *       designated the master. A slider is only a master while the
   *       user is making a change.
   *
   *    subordinates:
   *
   *       When the user is altering a slider value, all of the other
   *       sliders, minus those which are disabled, are considered
   *       subordinates. The subordinates are the sliders whose values
   *       are changes to ensure that the group remains balanced.
   */
  function Balancer (options) {
    _.bindAll(this, 'onBegin', 'onChange', 'onCommit', 'onAbort');

    this.options = _.clone(options || {});
    this.views   = [];
    this.quinns  = [];
    this.max     = this.__getMax();

    this.masterId     = null;
    this.subordinates = null;
  }

  // Holds balancer instances so that InputElements may automatically
  // add themselves to the correct balancer when initialzed.
  Balancer.balancers = {};

  // Gets the Balancer with the given name. If one does not exist, it
  // will be created with the given options.
  Balancer.get = function (name, options) {
    if (! Balancer.balancers[name]) {
      Balancer.balancers[name] = new Balancer(options);
    }

    return Balancer.balancers[name];
  };

  // Balancer triggers Quinn-like begin, change, commit, and abort events when
  // the master slider is adjusted.
  _.extend(Balancer.prototype, Backbone.Events);

  /**
   * ### add
   *
   * Given an initialized InputElementView, adds the view to the group and
   * will balance the slider value when it, or other sliders, have their value
   * changed.
   *
   * Note that add expects an InputElementView, not an InputElement.
   */
  Balancer.prototype.add = function (inputView) {
    var quinn = inputView.quinn;

    quinn.balanceId = _.uniqueId('balance_');

    quinn.bind('begin',  this.onBegin);
    quinn.bind('change', this.onChange);
    quinn.bind('commit', this.onCommit);
    quinn.bind('abort',  this.onAbort);

    this.views.push(inputView);
    this.quinns.push(inputView.quinn);

    this.max = this.__getMax();

    return this;
  };

  /**
   * Triggered when the user alteres a slider; performs balancing of the
   * subordinates.
   */
  Balancer.prototype.doBalance = function (newValue, quinn) {
    var self          = this,
        iterations    = 20,
        amountChanged = newValue - quinn.value,

        flex, sliders, sLength, prevValue, i;

    // Return quickly; if the amount changed is larger than max, then the
    // change is impossible
    if (amountChanged > this.max) {
      return false;
    }

    // Adjust the subordinate sliders to balance; max 20 iterations.
    while (iterations--) {
      console.log('iteration', 20-iterations);

      // Determine which sliders can be altered; of the subordinates, some may
      // already be at their maximum or minimum values, so there's no point
      // changing those.
      sliders = _.select(this.subordinates, function (sub) {
        if (amountChanged >= 0) {
          // Master slider is being increased.
          return (sub.value > sub.selectable[0]);
        } else {
          // Master slider is being reduced.
          return (sub.value < sub.selectable[1]);
        }
      });

      if ((sLength = sliders.length) === 0) {
        // All subordinates are at their min or max value; the change is
        // impossible.
        return false;
      }

      // Flex is the balance maximum value, minus the value of those
      // sliders which may be altered.
      flex = this.max - (_.sum(_.pluck(sliders, 'value')) + newValue);

      for (i = 0; i < sLength; i++) {
        // Adjust each slider.
        prevValue = sliders[i].value;
        sliders[i].__setValue(prevValue + flex);

        // Reduce the value which subsequent iterations much change.
        amountChanged -= (prevValue - sliders[i].value);
      }

      // All done? In some cases the remaining amount may be
      // 1.0e-15, hence the -1 > n < n
      if (amountChanged < 1 && amountChanged > -1) {
        return true;
      }
    }
  };

  /**
   * Returns the sum of all of the slider values.
   */
  Balancer.prototype.getSum = function () {
    return _.reduce(this.quinns, function (sum, quinn) {
      return sum + quinn.value;
    });
  };

  // ### Events.

  Balancer.prototype.onBegin = function (value, quinn) {
    // If no slider is already being adjusted, then this is when the
    // user begins moving a slider.
    if (this.masterId === null) {
      this.masterId     = quinn.balanceId;
      this.subordinates = this.__getSubordinates();

      this.__runOnSubordinates('__willChange');

      this.trigger('begin');
    }

    // Otherwise is is an onBegin event being fired when a subordinate
    // slider is being balanced; ignore it.
  };

  Balancer.prototype.onChange = function (value, quinn) {
    // Fired when a slider value is changed; we only want to track
    // changes to the master slider, as the onChange event for the
    // subordinates should be ignored.
    if (this.isMaster(quinn)) {
      if (this.doBalance(value, quinn) === false) {
        // Can't do the balance, so we prevent the slider movement.
        return false;
      }

      this.trigger('change');
    }
  };

  Balancer.prototype.onCommit = function (value, quinn) {
    if (this.isMaster(quinn)) {
      this.__finish('__hasChanged');
      this.trigger('commit');
    }
  };

  Balancer.prototype.onAbort = function (value, quinn) {
    if (this.isMaster(quinn)) {
      this.__finish('__abortChange');
      this.trigger('abort');
    }
  };

  // ### Pseudo-Private Methods.

  /**
   * Returns all the sliders except the one with which the user is
   * interacting, minus those which are disabled.
   */
  Balancer.prototype.__getSubordinates = function () {
    var self = this;

    return _.select(this.quinns, function (quinn) {
      return (! self.isMaster(quinn) && ! quinn.isDisabled)
    });
  };

  /**
   * #### _getMax
   *
   * Returns the maximum permitted cumulative value of the sliders which are
   * members of the group. This is cached as this.max.
   */
  Balancer.prototype.__getMax = function () {
    if (this.options.max) {
      return this.options.max;
    }

    // No explicit max, just use the total of all the sliders (no balancing).
    return _.reduce(this.views, function (sum, view) {
      return (sum + view.quinn.range[1]);
    }, 0) / this.views.length;
  };

  /**
   * Finishes editing slider values by resetting this.masterId and
   * this.subordinates, and calling 'method' on the subordinates.
   */
  Balancer.prototype.__finish = function (method) {
    this.__runOnSubordinates(method);

    this.masterId     = null;
    this.subordinates = null;
  };

  /**
   * Runs a method on all the subordinates.
   */
  Balancer.prototype.__runOnSubordinates = function (method) {
    var subLength = this.subordinates.length, i;

    for (i = 0; i < subLength; i++) {
      this.subordinates[i][method]();
    }
  };

  /**
   * Returns if the given Quinn instance is the current master slider.
   */
  Balancer.prototype.isMaster = function (quinn) {
    return (this.masterId !== null &&
            this.masterId === quinn.balanceId)
  };

  // ## Globals
  window.InputElement.Balancer = Balancer;

})(window);
