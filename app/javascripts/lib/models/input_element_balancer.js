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

    this.options   = _.clone(options || {});
    this.max       = this.__getMax();
    this.precision = 1;

    this.views  = [];
    this.quinns = [];

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

    this.max       = this.__getMax();
    this.precision = this.__getPrecision();

    return this;
  };

  /**
   * Triggered when the user alteres a slider; performs balancing of the
   * subordinates.
   */
  Balancer.prototype.doBalance = function (newValue, quinn) {
    var iterations    = 20,
        amountChanged = newValue - quinn.value,

        originalValues, originalQuinns,

        flexPerSlider, flex, sliders, sLength, slider,
        previousFlex, nextIterationSliders, i;

    // Return quickly; if the amount changed is larger than max, then the
    // change is impossible
    if (amountChanged > this.max) {
      return false;
    }

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
      // All subordinates are at their min or max value; the change is not
      // possible.
      return false;
    }

    originalQuinns = sliders;
    originalValues = _.reduce(sliders, function (vals, quinn) {
      vals[quinn.balanceId] = quinn.value;
      return vals;
    }, {});

    // Flex is the balance maximum value, minus the value of those sliders
    // which may be altered.
    // Flex is the amount of "value" which needs to be adjusted for. e.g.
    //
    //    max: 100
    //    slider 1: 0
    //    slider 2: 100
    //
    //  If slider 1 is moved to 25, the Flex is -25, since in order to balance
    //  the sliders we need to subtract 25 from the subordinate sliders.
    //
    flex = _.sum(_.pluck(sliders, 'value')) + newValue;
    flex = this.snapValue(this.max - flex);

    while (iterations--) {
      nextIterationSliders = [];

      for (i = 0; i < sLength; i++) {
        // The amount of flex to be given to each slider. Calculated each time
        // we balance a slider since the previous slider may have used up all
        // of the flex if it was less than the smallest slider step value (with
        // a step value of 0.1, in a three-slider group, a per-subordinate
        // change of 0.05 would round UP to 0.1, leaving no flex for the
        // second slider).
        flexPerSlider = this.snapValue(flex / (sLength - i));

        slider    = sliders[i];
        prevValue = slider.value;

        slider.__setValue(this.snapValue(prevValue + flexPerSlider));

        // Reduce the flex by the amount by which the slider was changed, in
        // case more iterations are required.
        flex = this.snapValue(flex - (slider.value - prevValue));

        // Finally, if this slider still can be moved further as it isn't at
        // it's min or max selectable value, it may be used again in the next
        // iteration.
        if ((flex < 0 && slider.value !== slider.selectable[0]) ||
            (flex > 0 && slider.value !== slider.selectable[1])) {
          nextIterationSliders.push(slider);
        } else if (flex === 0) {
          break; // We're done!
        }
      }

      sliders = nextIterationSliders;
      sLength = sliders.length;

      // Can't go any further; either we used up all the flex successfully
      // balancing the sliders, or the flex was unchanged from the previous
      // iterations, in which case balancing isn't possible.
      if (this.snapValue(flex) === 0.0 || previousFlex === flex) {
        break;
      }

      previousFlex = flex;
    }

    if (this.snapValue(flex) !== 0.0) {
      this.__revert(originalQuinns, originalValues);
      return false;
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

  /**
   * Given a float, "snaps" it to match the precision (i.e. if the smallest
   * step value of any of the balanced sliders is 0.1, it will round the
   * number to the nearest 0.1). Used heavily in doBalance to account for the
   * _vast_ number of floating point errors which occur when a group contains
   * three or more sliders.
   */
  Balancer.prototype.snapValue = function (value) {
    return parseFloat(value.toFixed(this.precision));
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
   * Since many sliders use a fractional step value, and floating point
   * arithmetic is a nightmare, determine the number of decimal places used in
   * the smallest slider step value, so that we can do all balancing using
   * integers.
   */
  Balancer.prototype.__getPrecision = function () {
    var precision = _.max(_.map(this.quinns, function (quinn) {
      var strStep = quinn.options.step.toString().split('.');
      return parseInt((strStep[1] || '').length, 10);
    }));

    return precision || 0;
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
   * Given an array of sliders, returns an object with their values keyed on
   * the balance ID assigned to the slider.
   */
  Balancer.prototype.__originalValues = function (quinns) {
    var values  = {},
        qLength = quinns.length,
        i;

    for (i = 0; i < qLength; i++) {
      values[quinns[i].balanceId] = quinns[i].value;
    }

    return values;
  };

  /**
   * Given an array of subordinates, and a hash of balance IDs and values,
   * restores each slider to it's value prior to being changed.
   *
   * Used when balancing fails.
   */
  Balancer.prototype.__revert = function (quinns, values) {
    var length = quinns.length, i;

    for (i = 0; i < length; i++) {
      quinns[i].__setValue(values[quinns[i].balanceId]);
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
