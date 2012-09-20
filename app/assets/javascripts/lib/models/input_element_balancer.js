(function (window) {
  'use strict';

  // Input groups which require all the sliders to be sent to ETengine.
  var SEND_ENTIRE_GROUP = [ 'coal_lce', 'gas_lce', 'nuclear_lce' ];

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
    _.bindAll(this, 'begin', 'drag', 'change', 'abort');

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

  // Bits of extra precision used when storing and manipulating grouped
  // inputs. This is internal only; numbers are still displayed to the user
  // rounded to the input "step" value.
  Balancer.EXTRA_PRECISION = 6;

  // ## Instance-Level Stuff -------------------------------------------------

  /**
   * Adds a slider to be balanced. Note that `add` expects an
   * InputElementView, _not_ an InputElement.
   */
  Balancer.prototype.add = function (inputView) {
    var quinn = inputView.quinn;

    quinn.balanceId = _.uniqueId('balance_');

    quinn.on('begin',  this.begin);
    quinn.on('drag',   this.drag);
    quinn.on('change', this.change);
    quinn.on('abort',  this.abort);

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
    var amountChanged = newValue - this.oValues.value(quinn),
        valuesBeforeBalancing, flex, sLength, slider, prevValue, i;

    // Return quickly: if the amount changed is larger than the balancer
    // allows as the change is impossible.
    if (amountChanged > this.max || amountChanged < -this.max) {
      return false;
    }

    if ((sLength = this.subordinates.length) === 0) {
      // Return quickly if all none of the subordinate sliders can be moved
      // any further.
      return false;
    }

    valuesBeforeBalancing = new OriginalValues(this.subordinates);

    // Flex is the amount of "value" which needs to be adjusted for. e.g.
    //
    //    max: 100
    //    slider 1: 0
    //    slider 2: 100
    //
    //  If slider 1 is moved to 25, the flex is -25 since in order to balance
    //  the sliders we need to subtract 25 from the subordinates.
    //
    flex = this.oValues.sumOf(this.subordinates) + newValue;
    flex = this.snapValue(this.max - flex);

    for (i = 0; i < sLength; i++) {
      // The balancer seeks to assign the full flex amount to one slider; if
      // this can't be done, it moves on to the next slider, and keeps going
      // until either all of the flex has been assigned, or we run out of
      // sliders.

      slider    = this.subordinates[i];
      prevValue = this.oValues.value(slider);

      slider.setTentativeValue(prevValue + flex);

      // Reduce the flex by the amount by which the slider was changed,
      // ready for the next slider.
      flex = this.snapValue(flex - (slider.model.value - prevValue));
    }

    if (flex !== 0) {
      valuesBeforeBalancing.revert();
      return false;
    }

    return true;
  };

  /**
   * When balancing fails with the user-given value, this function will find
   * the closest value which works, while also adjusting the subordinate
   * inputs to keep the group balancing. For example:
   *
   *             Min             Max - Start
   *    Input A:  0 |O---------|  20 -   0
   *    Input B:  0 |O---------|  20 -   0
   *    Input C:  0 |---------O| 100 - 100
   *
   * In this example, the lowest possible value for C is "60", because neither
   * inputs A nor B can be increased higher than "20". If the user rapidly
   * decreases the value of C, trying to set a value less than 60, it will
   * often get stuck at a value close to -- but not exactly -- 60. There
   * aren't enough pixels on the screen to represent the "60" value precisely.
   *
   * In these cases, the balancer will invoke `balanceToClosestEquilibrium` to
   * find the closest acceptable value.
   */
  Balancer.prototype.balanceToClosestEquilibrium = function (quinn, target) {
    var isIncreasing = (target > quinn.previousValue),
        lower        = (isIncreasing ? quinn.previousValue : target),
        upper        = (isIncreasing ? target : quinn.previousValue),
        midPoint, knownGood, previous;

    while (true) {
      midPoint = this.snapValue((lower + upper) / 2);

      if (midPoint === previous) {
        // We have run out of values to test.
        return (knownGood != null) ? knownGood : false;
      }

      if (this.doBalance(midPoint, quinn)) {
        knownGood = midPoint;
        isIncreasing ? (lower = midPoint) : (upper = midPoint);
      } else {
        isIncreasing ? (upper = midPoint) : (lower = midPoint);
      }

      // Pass this iterations midPoint to the next iteration; if it's
      // midPoint is identical (which can happen due to rounding), we stop.
      previous = midPoint;
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

  /**
   * Resetting a single slider in a group resets them all to their original
   * values.
   */
  Balancer.prototype.resetAll = function () {
    try {
      this.isDisabled = true;
      _.invoke(this.views, 'resetValue', false);
    } finally {
      this.isDisabled = false;
    }
  };

  // ## Event-Handling -------------------------------------------------------

  Balancer.prototype.begin = function (value, quinn) {
    if (this.isDisabled) {
      return true;
    }

    // If no slider is already being adjusted, then this is when the
    // user begins moving a slider.
    if (this.masterId === null) {
      this.masterId     = quinn.balanceId;
      this.subordinates = this.__getSubordinates();
      this.oValues      = new OriginalValues(this.quinns);

      this.__runOnSubordinates('start');

      this.trigger('begin');
    }

    // Otherwise is is an begin event being fired when a subordinate slider is
    // being balanced; ignore it.
  };

  Balancer.prototype.drag = function (value, quinn) {
    // Fired when a slider value is changed. We only care about changes to the
    // master slider, and subordinates are ignored.
    if (this.isMaster(quinn)) {
      if (this.doBalance(value, quinn) === false) {
        // Can't do the balance with the user's value, try to find the closest
        // acceptable value.
        var fallback = this.balanceToClosestEquilibrium(quinn, value);

        if (fallback === false) {
          return false;
        } else {
          quinn.setTentativeValue(fallback, false, false);
        }
      }

      this.trigger('drag');
    }
  };

  Balancer.prototype.change = function (value, quinn) {
    if (this.isMaster(quinn)) {
      this.__sliderUsed(quinn);
      this.__finish('resolve');
      this.trigger('commit');
    }
  };

  Balancer.prototype.abort = function (value, quinn) {
    if (this.isMaster(quinn)) {
      this.__finish('reject');
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
      // Inputs in groups may have rounding errors (etmodel#1023) if
      // insufficient precision is used. So, we add extra bits of precision
      // in hope that this is enough to keep the group balancing.
      return view.conversion.precision + Balancer.EXTRA_PRECISION;
    })) || 0;
  };

  /**
   * Finishes editing slider values by resetting this.masterId and
   * this.subordinates, and calling 'method' on the subordinates.
   */
  Balancer.prototype.__finish = function (method) {
    var groupName = this.views[0].model.get('share_group'),
        i, length;

    this.__runOnSubordinates(method);

    if (method === 'resolve' && _.include(SEND_ENTIRE_GROUP, groupName)) {
      // ETengine wants the whole group to be marked dirty.
      for (i = 0, length = this.views.length; i < length; i++) {
        this.views[i].model.markDirty();
      }
    }

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
      this.values[quinns[i].balanceId] = quinns[i].model.value;
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
      this.quinns[i].setTentativeValue(
        this.values[ this.quinns[i].balanceId ]
      );
    }
  };

  // # Globals ---------------------------------------------------------------

  window.InputElement.Balancer = Balancer;

})(window);
