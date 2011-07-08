(function (window) {
  'use strict';

  /**
   * Creates a balancer instance.
   *
   * Terminology:
   *
   *    master:
   *
   *       When the user begins to alter a slider, this slider is designated
   *       the master. A slider is only a master while the user is making a
   *       change.
   *
   *    subordinates:
   *
   *       When the user is altering a slider value, all of the other sliders,
   *       minus those which are disabled, are considered subordinates. The
   *       subordinates are the sliders whose values are changes to ensure
   *       that the group remains balanced.
   */
  function Balancer (options) {
    _.bindAll(this, 'onBegin', 'onChange', 'onCommit', 'onAbort');

    this.options   = _.clone(options || {});
    this.max       = this.__getMax();
    this.precision = 1;

    this.views      = [];
    this.quinns     = [];
    this.quinnOrder = [];

    this.oValues    = null;

    this.masterId     = null;
    this.subordinates = null;
  }

  // ## Class-Level Stuff ----------------------------------------------------

  // Balancer triggers Quinn-like begin, change, commit, and abort events when
  // the master slider is adjusted.
  _.extend(Balancer.prototype, Backbone.Events);

  // Holds balancer instances so that InputElements may automatically add
  // themselves to the correct balancer when initialzed.
  Balancer.balancers = {};

  // Gets the Balancer with the given name. If one does not exist, it
  // will be created with the given options.
  Balancer.get = function (name, options) {
    if (! Balancer.balancers.hasOwnProperty(name)) {
      Balancer.balancers[name] = new Balancer(options);
    }

    return Balancer.balancers[name];
  };

  // ## Instance-Level Stuff -------------------------------------------------

  /**
   * Adds a slider to be balanced. Note that `add` expects an
   * InputElementView, _not_ an InputElement.
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
    this.quinnOrder.push(quinn.balanceId);

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
        amountChanged = newValue - this.oValues.value(quinn),

        valuesBeforeBalancing,

        flexPerSlider, flex, sliders, sLength, slider, prevValue,
        previousFlex, nextIterationSliders, i;

    // Return quickly: if the amount changed is larger than the balancer
    // allows as the change is impossible.
    if (amountChanged > this.max || amountChanged < -this.max) {
      return false;
    }

    // Determine which sliders can be altered; of the subordinates, some may
    // already be at their maximum or minimum values, so there's no point
    // changing those.
    sliders = _.select(this.subordinates, function (sub) {
      var value = this.oValues.value(sub);

      if (amountChanged >= 0) {
        // Master slider is being increased.
        return (value > sub.selectable[0]);
      } else {
        // Master slider is being reduced.
        return (value < sub.selectable[1]);
      }
    }, this);

    if ((sLength = sliders.length) === 0) {
      // Return quickly if all none of the subordinate sliders can be moved
      // any further.
      return false;
    }

    valuesBeforeBalancing = new OriginalValues(sliders);

    // Flex is the amount of "value" which needs to be adjusted for. e.g.
    //
    //    max: 100
    //    slider 1: 0
    //    slider 2: 100
    //
    //  If slider 1 is moved to 25, the flex is -25 since in order to balance
    //  the sliders we need to subtract 25 from the subordinates.
    //
    flex = this.oValues.sumOf(sliders) + newValue;
    flex = this.snapValue(this.max - flex);

    while (iterations--) {
      nextIterationSliders = [];

      for (i = 0; i < sLength; i++) {
        // The amount of flex given to each slider. Calculated each time we
        // balance a slider since the previous one may have used up all of the
        // available flex the flexPerSlider was rounded up by the slider's
        // __setValue method.
        //
        // For example, a flexPerSlider of 0.05, and a slider step value of
        // 0.1 would result in 0.05 being round up, leaving no flex for the
        // second slider.
        flexPerSlider = this.snapValue(flex / (sLength - i));

        slider    = sliders[i];
        prevValue = slider.value;

        if (iterations === 19) {
          // first iteration.
          prevValue = this.oValues.value(slider);
        }

        if (slider.__setValue(prevValue + flexPerSlider)) {
          this.__sliderUsed(slider);
        }

        // Reduce the flex by the amount by which the slider was changed,
        // ready for subsequent iterations.
        flex = this.snapValue(flex - (slider.value - prevValue));

        // Finally, if this slider still can be moved further, it may be used
        // again in the next iteration.
        if ((flex < 0 && slider.value !== slider.selectable[0]) ||
            (flex > 0 && slider.value !== slider.selectable[1])) {
          nextIterationSliders.push(slider);
        }
      }

      sliders = nextIterationSliders;
      sLength = sliders.length;

      // We can't go any further if flex is 0, or if the flex value hasn't
      // changed in this iteration.
      if (flex === 0 || previousFlex === flex) {
        break;
      }

      previousFlex = flex;
    }

    if (flex !== 0) {
      valuesBeforeBalancing.revert();
      return false;
    }
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

  /**
   * Returns if the given Quinn instance is the current master slider.
   */
  Balancer.prototype.isMaster = function (quinn) {
    return (this.masterId !== null &&
            this.masterId === quinn.balanceId);
  };

  // ## Event-Handling -------------------------------------------------------

  Balancer.prototype.onBegin = function (value, quinn) {
    // If no slider is already being adjusted, then this is when the
    // user begins moving a slider.
    if (this.masterId === null) {
      this.masterId     = quinn.balanceId;
      this.subordinates = this.__getSubordinates();
      this.oValues      = new OriginalValues(this.quinns);

      this.__runOnSubordinates('__willChange');

      this.trigger('begin');
    }

    // Otherwise is is an onBegin event being fired when a subordinate
    // slider is being balanced; ignore it.
  };

  Balancer.prototype.onChange = function (value, quinn) {
    // Fired when a slider value is changed. We only care about changes to the
    // master slider, and subordinates are ignored.
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

  // ## Pseudo-Private Methods -----------------------------------------------

  /**
   * Returns all the sliders except the one with which the user is
   * interacting and those which are disabled.
   */
  Balancer.prototype.__getSubordinates = function () {
    var self = this, subs;

    subs = _.select(this.quinns, function (quinn) {
      return (! self.isMaster(quinn) && ! quinn.isDisabled);
    });

    if (this.quinns.length <= 2) {
      return subs;
    }

    // The subs are now re-ordered so that the most recently used sliders are
    // at the end of the array. Otherwise doBalance is somewhat biased towards
    // the first slider.
    return _.sortBy(subs, function (quinn) {
      return _.indexOf(self.quinnOrder, quinn.balanceId);
    });
  };

  /**
   * Marks a slider as used, pushing it to the back of the quinnOrder array.
   * This prevents doBalance favouring balancing one slider over the others.
   */
  Balancer.prototype.__sliderUsed = function (quinn) {
    if (this.quinns.length <= 2) {
      return true;
    }

    var balanceId = quinn.balanceId;

    this.quinnOrder = _.without(this.quinnOrder, balanceId);
    this.quinnOrder.push(balanceId);
  };

  /**
   * Returns the maximum permitted cumulative value of the sliders which are
   * members of the group. This is cached as this.max.
   */
  Balancer.prototype.__getMax = function () {
    if (this.options.max) {
      return this.options.max;
    }

    // No explicit max, just use the total of all the sliders (no balancing).
    return _.reduce(this.quinns, function (sum, quinn) {
      return (sum + quinn.range[1]);
    }, 0) / this.quinns.length;
  };

  /**
   * Since many sliders use a fractional step value, and floating point
   * arithmetic is a nightmare, determine the number of decimal places used in
   * the smallest slider step value, so that we can do all balancing using
   * integers.
   */
  Balancer.prototype.__getPrecision = function () {
    return _.max(_.map(this.views, function (view) {
      return view.conversion.precision;
    })) || 0;
  };

  /**
   * Finishes editing slider values by resetting this.masterId and
   * this.subordinates, and calling 'method' on the subordinates.
   */
  Balancer.prototype.__finish = function (method) {
    this.__runOnSubordinates(method);

    this.masterId     = null;
    this.subordinates = null;
    this.oValues      = null;
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

  // # OriginalValues --------------------------------------------------------

  /**
   * Given an array of Quinn instances, OriginalValues keeps track of the
   * value of each slider at the time the OriginalValues instance was created.
   */
  function OriginalValues (quinns) {
    var i;

    this.length = quinns.length;
    this.quinns = quinns;
    this.values = {};

    for (i = 0; i < this.length; i++) {
      this.values[quinns[i].balanceId] = quinns[i].value;
    }
  }

  /**
   * Given a Quinn instance, returns the value of that instance at the time
   * the OriginalValues was initialized.
   */
  OriginalValues.prototype.value = function (quinn) {
    return this.values[quinn.balanceId];
  };

  /**
   * Given an array of Quinns, returns the sum of their values at the time the
   * OriginalValues was initialized.
   */
  OriginalValues.prototype.sumOf = function (sliders) {
    var sLength = sliders.length, sum = 0, i;

    for (i = 0; i < sLength; i++) {
      sum += this.value(sliders[i]);
    }

    return sum;
  };

  /**
   * Reverts the Quinn instances back to their original value.
   */
  OriginalValues.prototype.revert = function () {
    var i;

    for (i = 0; i < this.length; i++) {
      this.quinns[i].__setValue(this.values[ this.quinns[i].balanceId ]);
    }
  };

  // # Globals ---------------------------------------------------------------

  window.InputElement.Balancer = Balancer;

})(window);
