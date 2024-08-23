/* globals $ _ App Backbone flowplayer globals I18n InputElement Metric */
(function (window) {
  'use strict';

  var BODY_HIDE_EVENT,
    ACTIVE_VALUE_SELECTOR,
    INPUT_ELEMENT_T,
    VALUE_SELECTOR_T,
    CONVERTER_INFO_T,
    HOLD_DELAY,
    HOLD_DURATION,
    HOLD_FPS,
    IS_IE_LTE_EIGHT,
    ACTIVE_INFO_BOX,
    buildAdditionalSpecs,
    floatPrecision,
    conversionsFromModel,
    abortValueSelection,
    bindValueSelectorBodyEvents,
    InputElementView,
    ValueSelector;

  // # Constants -------------------------------------------------------------

  // The number of milliseconds which pass before stepping up and down values
  // should begin being repeated.
  HOLD_DELAY = 500;
  HOLD_DURATION = 2000;
  HOLD_FPS = 60;

  // Tracks whether the body has been assigned an event to hide input
  // selection boxes when the user clicks outside them.
  BODY_HIDE_EVENT = false;

  // Holds the ID of the currently displayed value selector so it can be
  // hidden if the user clicks outside of it.
  ACTIVE_VALUE_SELECTOR = null;

  // Detect IE8 so that we can use the custom PNG when disabled, since it
  // managed to screw up opacity so spectacularly.
  IS_IE_LTE_EIGHT = $.browser.msie && $.browser.version <= 8;

  // Templates.
  $(function () {
    if (document.querySelector('#input-element-template')) {
      INPUT_ELEMENT_T = _.template($('#input-element-template').html());
      VALUE_SELECTOR_T = _.template($('#value-selector-template').html());
    }
    if (document.querySelector('#node-details-template')) {
      CONVERTER_INFO_T = _.template($('#node-details-template').html());
    }
  });

  /**
   * Given an integer or float, returns how many decimal places are present,
   * so that other numbers can be displayed with the same precisioin with
   * toFixed().
   */
  floatPrecision = function (value, delta) {
    var precision = 0,
      asString;

    if (_.isNumber(value)) {
      asString = value.toString();

      if (asString.match(/e/)) {
        precision = Number.parseInt(asString.split(/e[+-]/)[1], 10);
      } else {
        precision = value.toString().split('.');
        precision = precision[1] ? precision[1].length : 0;
      }
    }

    return precision;
  };

  /**
   * Creates an array of UnitConversions suitable for displaying an
   * InputElement model.
   *
   * Conversions come from the application as a hash where each key is an I18n
   * key, and each value an array in the format [ unit, multiplier ].
   */
  conversionsFromModel = function (model) {
    var conversions = [],
      modelConvs = model.conversions(),
      mPrecision = floatPrecision(
        model.smartStep(),
        model.get('max_value') - model.get('min_value')
      ),
      customDefault = false,
      i;

    conversions.push(
      new UnitConversion(
        {
          name: I18n.t('unit_conversions.default'),
          unit: model.get('unit'),
          multiplier: 1,
        },
        mPrecision
      )
    );

    for (i = 0; i < modelConvs.length; i++) {
      conversions.push(
        new UnitConversion(
          {
            name: modelConvs[i].unit,
            unit: modelConvs[i].unit,
            multiplier: modelConvs[i].multiplier,
            default: modelConvs[i].default,
          },
          mPrecision
        )
      );

      if (modelConvs[i].default) {
        customDefault = true;
      }
    }

    conversions[0].default = !customDefault;

    return _.sortBy(conversions, function (c) {
      return c.name;
    });
  };

  /**
   * Closes the currently open value selector without changing the value.
   */
  abortValueSelection = function (event) {
    if (!ACTIVE_VALUE_SELECTOR) {
      return true;
    }

    // Hide if the element clicked was not the value selection elemnt, or a
    // child of the selection element.
    if (
      !$(event.target)
        .closest('#' + ACTIVE_VALUE_SELECTOR)
        .get(0)
    ) {
      $('#' + ACTIVE_VALUE_SELECTOR)
        .fadeOut('fast')
        .parent('.new-input-slider')
        .css('z-index', 10);

      ACTIVE_VALUE_SELECTOR = null;
    }
  };

  /**
   * When the first ValueSelector is created, some events need to be added to
   * the body element to make things a little more intuitive:
   *
   *  - binds a click event such that clicking outside the selector closes it,
   *  - binds a keyup so that hitting [Escape] closes the selector.
   */
  bindValueSelectorBodyEvents = function () {
    if (BODY_HIDE_EVENT) {
      return true;
    }

    var $body = $('body');

    $body.click(abortValueSelection).keyup(function (event) {
      if (event.which === 27) {
        $body.click();
      }
    });

    BODY_HIDE_EVENT = true;
  };

  /**
   * Receives an object containing additional data to be shown in the
   * technical stats table and formats it to match the structure of that
   * returned by ETEngine.
   */
  buildAdditionalSpecs = function (data) {
    var newData = {};

    if (!data) {
      return newData;
    }

    var entries = Object.entries(data);

    for (var i = 0; i < entries.length; i++) {
      var groupData = entries[i];

      var groupName = groupData[0];
      var attrs = groupData[1];
      var newGroupData = {};

      newData[groupName] = newGroupData;
      var groupEntries = Object.entries(attrs);

      for (var j = 0; j < entries.length; j++) {
        var entry = groupEntries[i];

        newGroupData[entry[0]] = {
          future: entry[1],
          desc: entry[0],
          present: entry[1],
        };
      }
    }

    return newData;
  };

  /**
   * Converts an object containing technical specification for a node to a
   * sorted array of spec groups and attributes.
   */
  var specsToList = function (data) {
    var groups = _.sortBy(Object.entries(data), function (group, index) {
      switch (group[0]) {
        case 'technical':
          return 0;
        case 'cost':
          return 1;
        case 'other':
          return Infinity;
        default:
          return index + 2; // ensure placement after technical and costs
      }
    }).map(function (entry) {
      return [I18n.t('node_details.groups.' + entry[0]), entry[1]];
    });

    return groups.map(function (group) {
      var attrs = Object.entries(group[1]).map(function (entry) {
        return $.extend(
          {
            name: I18n.t('node_details.attributes.' + entry[0]),
            description: I18n.t('node_details.descriptions.' + entry[0], { defaultValue: false }),
          },
          entry[1]
        );
      });

      return [group[0], attrs];
    });
  };

  // # UnitConversion --------------------------------------------------------

  function UnitConversion(data, originalPrecision) {
    this.name = data.name;
    this.multiplier = data.multiplier == undefined ? 1 : data.multiplier;
    this.unit = data.unit;
    this.uid = _.uniqueId('uconv_');
    this.default = data.default;

    if (data.precision == undefined) {
      this.precision = originalPrecision - floatPrecision(1 / this.multiplier);
    } else {
      this.precision = data.precision;
    }

    if (this.precision < 0) {
      this.precision = 0;
    }
  }

  /**
   * Given the slider value, formats the value taking into account the
   * conversion multiplier and precision. Returns a string.
   *
   * Optional noDelimiter parameter omits thousand separators from the output.
   *
   * For example:
   *
   *    u.format(2) # => "4.2"
   */
  UnitConversion.prototype.format = function (value, noDelimiter) {
    var multiplied = value * this.multiplier,
      precision = this.precision,
      power = Metric.power_of_thousand(multiplied),
      scale = '',
      formatted;

    if (power == 1) {
      // Don't show decimal places for numbers over 1000.
      precision = 0;
    } else if (power >= 2) {
      // Numbers over a million are shown as a power of 1000 with two decimal
      // places, otherwise they won't fit. For example, 22,512,188 becomes
      // "22.51 M".
      multiplied = multiplied / Math.pow(1000, power);
      precision = 2;
      scale = Metric.power_symbols[power];
    }

    formatted = I18n.toNumber(multiplied, {
      precision: precision,
      delimiter: noDelimiter ? '' : null,
    });

    if (multiplied == 0) {
      // Reformat, to ensure that we don't display "-0.0".
      return (0).toFixed(this.precision);
    }

    return scale ? formatted + ' ' + scale : formatted;
  };

  /**
   * Given the slider value, formats it taking into account the multiplier and
   * precision, and appends the unit suffix, such as would be displayed in the
   * <output/> element.
   *
   * For example:
   *
   *    u.formatWithUnit(2) # => "4.2 GW"
   */
  UnitConversion.prototype.formatWithUnit = function (value) {
    if (this.unit && this.unit.length > 0) {
      return this.format(value) + ' ' + this.unit;
    }

    return this.format(value);
  };

  /**
   * Given a converted value (such as one entered in the value input element,
   * converts it back to the value which should be used internally by Quinn to
   * represent the value.
   *
   * For example:
   *
   *    u.toInternal(4.2) # => 2.0
   */
  UnitConversion.prototype.toInternal = function (formatted) {
    return formatted * (1 / this.multiplier);
  };

  /**
   * Creates an <option> element which represents the unit conversion.
   */
  UnitConversion.prototype.toOptionEl = function () {
    return $('<option></option>').val(this.uid).text(this.name).attr('selected', this.default);
  };

  // # InputElementView ------------------------------------------------------

  InputElementView = Backbone.View.extend({
    events: {
      'touchend  .reset': 'resetValue',
      'click     .reset': 'resetValue',
      'mousedown .decrease': 'beginStepDown',
      'mousedown .increase': 'beginStepUp',
      'touchend  .show-info': 'toggleInfoBox',
      'click     .show-info': 'toggleInfoBox',
      'touchend  .output': 'showValueSelector',
      'click     .output': 'showValueSelector',
      'touchend  a.node_detail': 'showNodeDetail',
      'click     a.node_detail': 'showNodeDetail',
    },

    initialize: function () {
      _.bindAll(this, 'updateFromModel', 'updateIsDisabled', 'quinnOnChange', 'quinnOnCommit');

      this.conversions = conversionsFromModel(this.model);
      this.conversion = _.find(this.conversions, function (c) {
        return c.default;
      });

      this.valueSelector = new ValueSelector({ view: this });
      this.initialValue = this.model.get('start_value');

      if (this.initialValue == undefined) {
        this.initialValue = this.model.get('min_value');
      }

      // When the input minimum value is higher than the maximum, disable the
      // element so the user can't do anything with it.
      if (this.model.get('min_value') >= this.model.get('max_value')) {
        this.model.set({ disabled: true }, { silent: true });
      }

      // Keeps track of intervals used to repeat stepDown and stepUp
      // operations when the user holds down the mouse button.
      this.incrementInterval = null;

      // When the user rapidly clicks the "step up" and "step down" buttons,
      // we delay setting the value on the model until we think they have
      // finished. This holds the timeout ID.
      this.resolveTimeout = null;
      this.lastStepClick = null;

      this.model.bind('change', this.updateFromModel);

      this.model.bind(
        'change:user_value',
        _.bind(function () {
          this.setTransientValue(this.model.get('user_value'));
        }, this)
      );

      // Hold off rendering until the document is ready (and the templates
      // have been parsed).
      $(
        _.bind(function () {
          this.render();
        }, this)
      );
    },

    // Rendering ---------------------------------------------------------------

    /**
     * Creates the HTML elements used to display the slider.
     */
    render: function () {
      var quinnStep = this.model.smartStep();

      if (this.model.get('share_group')) {
        // Inputs in groups may have rounding errors (etmodel#1023) if
        // insufficient precision is used. So, we add extra bits of precision
        // in hope that this is enough to keep the group balancing.
        quinnStep /= Math.pow(10, InputElement.Balancer.EXTRA_PRECISION);
      }

      // TEMPLATING.

      this.$el.addClass('new-input-slider').html(
        INPUT_ELEMENT_T({
          name: this.model.get('translated_name'),
          info: this.model.get('sanitized_description'),
          sublabel: this.model.get('label'),
          coupling: this.model.get('coupled'),
          node: this.model.get('related_node'),
          node_source: this.model.get('node_source_url'),
          input_element_key: this.model.get('key'),
          end_year: App.settings.get('end_year'),
          info_link: I18n.t('input_elements.common.info_link'),
          coupling_icon: this.model.get('coupling_icon'),
          info_coupling: I18n.t('input_elements.common.info_coupling'),
        })
      );

      this.resetElement = this.$('.reset');
      this.decreaseElement = this.$('.decrease');
      this.increaseElement = this.$('.increase');
      this.valueElement = this.$('.output');

      // INITIALIZATION.

      // new $.Quinn is an alternative to $(...).quinn(), and allows us to
      // easily keep hold of the Quinn instance.
      this.quinn = new $.Quinn(this.$('.quinn'), {
        min: this.model.get('min_value'),
        max: this.model.get('max_value'),

        value: this.model.get('user_value'),
        step: quinnStep,
        disable: this.model.isDisabled(),

        drawTo: {
          left: this.model.drawToMin(),
          right: this.model.drawToMax(),
        },

        // Don't round initial values which don't fit the step.
        strict: false,

        // Disable effects on sliders which are part of a group, since the
        // animation can look a little jarring.
        effects: !this.model.get('share_group'),

        // Keyboard events have a 300ms delay so that repeat keypresses don't
        // flood ETengine.
        keyFloodWait: 300,

        // No opacity for IE <= 8.
        disabledOpacity: IS_IE_LTE_EIGHT ? 1 : 0.5,
      });

      this.steppedInitialValue = this.quinn.model.sanitizeValue(this.initialValue);

      // The group onChange needs to be bound before the InputElementView
      // onChange, or the displayed value may be updated even though the
      // actual value doesn't change.
      if (this.model.get('share_group')) {
        InputElement.Balancer.get(this.model.get('share_group'), {
          max: 100,
        }).add(this);
      }

      this.quinn.on('drag', this.quinnOnChange);
      this.quinn.on('change', this.quinnOnCommit);

      // Need to do this manually, since it needs this.quinn to be set.
      this.quinnOnChange(this.quinn.model.value, this.quinn);
      this.updateSublabel(this.quinn.model.value);

      if (this.model.get('disabled')) {
        this.updateIsDisabled(this.model, true);
      }

      this.model.bind('change:disabled', this.updateIsDisabled);

      this.refreshButtons();

      return this;
    },

    /**
     * Disable min / max button if the input is set to it's lowest or highest
     * permitted value, and the reset button if the current slider value is
     * the original value.
     */
    refreshButtons: function () {
      var value = this.quinn.model.value;

      if (this.model.get('disabled')) {
        this.disableButton('decrease');
        this.disableButton('increase');
        this.disableButton('reset');

        return true;
      }

      if (value === this.quinn.model.minimum) {
        this.disableButton('decrease');
        this.enableButton('increase');
      } else if (value === this.quinn.model.maximum) {
        this.disableButton('increase');
        this.enableButton('decrease');
      } else {
        this.enableButton('decrease');
        this.enableButton('increase');
      }

      if (value === this.initialValue || value === this.steppedInitialValue) {
        this.disableButton('reset');
      } else {
        this.enableButton('reset');
      }
    },

    // Instance Methods --------------------------------------------------------

    /**
     * Disables a slider button.
     *
     * The sole argument should be the string "reset", "decrease", or
     * "increase" depending on which button you want to be disabled. All this
     * does is add a disabled class to the button, since the Quinn instance
     * will enforce that the value cannot be changed.
     */
    disableButton: function (buttonName) {
      var buttonElement = this[buttonName + 'Element'];
      buttonElement && buttonElement.addClass('disabled');
    },

    /**
     * Enables a slider button.
     *
     * The sole argument should be the string "reset", "decrease", or
     * "increase" depending on which button you want to be enabled.
     */
    enableButton: function (buttonName) {
      var buttonElement = this[buttonName + 'Element'];
      buttonElement && buttonElement.removeClass('disabled');
    },

    /**
     * Is called when something in the constraint model changed.
     */
    updateFromModel: function () {
      if (!this.disableUpdate) {
        return;
      }

      this.quinn.setValue(this.model.get('user_value'));

      return false;
    },

    /**
     * Is called when the models "disabled" attribute is changed.
     */
    updateIsDisabled: function (_model, isDisabled) {
      if (isDisabled) {
        this.$el.addClass('disabled');

        if (this.model.get('disabledByFeature')) {
          this.valueElement.html('&mdash;');
        } else {
          this.setTransientValue(this.quinn.model.value);
        }

        if (this.model.get('coupled')) {
          this.$el.addClass('hidden');
          this.valueElement.addClass('coupled');
          this.valueElement.html('');
        }

        this.quinn.disable();
      } else {
        this.$el.removeClass('disabled');
        this.$el.removeClass('hidden');
        this.valueElement.removeClass('coupled');
        this.setTransientValue(this.quinn.model.value);
        this.quinn.enable();
      }

      this.refreshButtons();
    },

    // Event Handlers ----------------------------------------------------------

    /**
     * Updates elements of the UI to show the new slider value, but does _not_
     * set the value on the model (which is done later). The value is set on
     * the model as part of the Quinn onCommit callback (see `render`).
     *
     * The `fromSlider` argument indicates whether the new value has come from
     * the Quinn slider, in which case we can trust the value to fit the step,
     * min, and max values, and do not need to run the Quinn callbacks.
     */
    setTransientValue: function (newValue, fromSlider) {
      if (!fromSlider) {
        newValue = this.quinn.setValue(newValue);
      }

      this.valueElement.html(this.conversion.formatWithUnit(newValue));

      return newValue;
    },

    /**
     * Updates the value in the sublabel element to reflect changes made to the
     * input value by the user.
     */
    updateSublabel: function (value) {
      if (this.model.get('unit') !== '%') {
        // Can't change label values for other units without more radical
        // changes in ETengine.
        return true;
      }

      var label = this.model.get('label'),
        conversion;

      if (label) {
        conversion = new UnitConversion({
          multiplier: value / 100 + 1,
          unit: label.suffix,
          precision: 2,
        });

        this.$el.find('.sublabel').html(conversion.formatWithUnit(label.value));
      }
    },

    /**
     * Resets the value of the slider to it's original value.
     */
    resetValue: function (event) {
      // Sliders which are part of a balancer should reset the whole group.
      // event will be false when the balancer calls resetValue so that
      // resetValue can easily be called to reset each slider in turn.
      if (event && this.model.get('share_group')) {
        InputElement.Balancer.get(this.model.get('share_group')).resetAll();
      } else {
        this.quinn.setValue(this.initialValue);

        // Quinn will round the value to the nearest step; to truely reset to
        // the original, we set the model to the initialValue.
        this.model.reset({ silent: true });

        // Ensure that the initial value of untouched inputs are also sent.
        this.model.markDirty();
      }
    },

    /**
     * Triggered when the users mouses-down on the decrease button. Reduces
     * the slider value by one step increment. If after HOLD_DELAY ms the
     * button is still being held down, the slider value will continue to be
     * decreased until either the minimum value is reached, or the user lifts
     * the button.
     */
    beginStepDown: function () {
      this.performStepping(this.quinn.model.minimum);
    },

    /**
     * Triggered when the users mouses-down on the increase button. Increases
     * the slider value by one step increment. If after HOLD_DELAY ms the
     * button is still being held down, the slider value will continue to be
     * decreased until either the minimum value is reached, or the user lifts
     * the button.
     */
    beginStepUp: function () {
      this.performStepping(this.quinn.model.maximum);
    },

    /**
     * Sets up events, intervals and timeouts when the user clicks the
     * increase or decrease buttons, such that the value continues to be
     * adjusted so long as they hold the mouse button.
     */
    performStepping: function (targetValue) {
      var self = this,
        initialValue = this.quinn.model.value,
        duration = HOLD_DURATION / (1000 / HOLD_FPS),
        isIncreasing = targetValue > initialValue,
        stepIterations = 0,
        wasHeld = false,
        delta = this.quinn.model.maximum - this.quinn.model.minimum,
        progress,
        timeoutId,
        intervalId,
        intervalFunc,
        onFinish;

      // --

      if (targetValue === initialValue || !this.quinn.start()) {
        return false;
      }

      if (this.resolveTimeout) {
        window.clearTimeout(this.resolveTimeout);
      }

      if (isIncreasing) {
        this.quinn.setTentativeValue(initialValue + this.model.smartStep());
      } else {
        this.quinn.setTentativeValue(initialValue - this.model.smartStep());
      }

      initialValue = this.quinn.model.value;

      // Reduce how long it takes to move the slider to the target value by
      // how close it is. For example, if moving from 0% to 100%, the movement
      // will take the full three seconds. If moving from 50% to 100%, it will
      // take 1.5 seconds, etc...
      duration *= Math.abs((targetValue - initialValue) / delta);

      // Interval function is what happens every 10 ms, where the slider value
      // is changed while the user continues to hold their mouse-button.
      intervalFunc = function () {
        progress = $.easing.easeInCubic(
          null,
          stepIterations++, // current time
          0,
          1, // start / finish value
          duration // total number of iterations
        );

        self.quinn.setTentativeValue(initialValue + (targetValue - initialValue) * progress);

        if (self.quinn.model.value === targetValue) {
          // We've reached the target value, so stop trying to move further.
          window.clearInterval(intervalId);
        }
      };

      // Set a timeout so that after HOLD_DELAY seconds, the slider value will
      // continue to be changed so long as the user holds the mouse button.
      timeoutId = window.setTimeout(function () {
        intervalId = window.setInterval(intervalFunc, 1000 / HOLD_FPS);
        wasHeld = true;
      }, HOLD_DELAY);

      // Executed when the user lifts the mouse button; commits the new value.
      onFinish = function () {
        var exec = function () {
          self.quinn.resolve();
          wasHeld = self.resolveTimeout = null;
        };

        $('body').off('mouseup.stepaccel');

        window.clearTimeout(timeoutId);
        window.clearInterval(intervalId);

        timeoutId = null;
        intervalId = null;

        if (wasHeld === true || !self.lastStepClick || new Date() - self.lastStepClick > 1000) {
          exec();
        } else {
          // When the user quickly clicked the button, we wait a bit just in
          // case they tap-tap-tap to make further changes.
          self.resolveTimeout = window.setTimeout(exec, 500);
        }

        // Log when the user lifted their mouse button; used so that single
        // clicks immediately update ETengine, while subsequent clicks will
        // wait until the user has finished.
        self.lastStepClick = new Date();
      };

      $('body').on('mouseup.stepaccel', onFinish);
    },

    /**
     * Toggles display of the slider information box.
     */
    toggleInfoBox: function () {
      var active = ACTIVE_INFO_BOX,
        infoBox = this.$('.info-wrap');

      if (infoBox.is(':visible')) {
        // Info box already open; user is closing it.
        ACTIVE_INFO_BOX = null;
      } else if (active && active !== this) {
        // Show this sliders info, another info box is already open. Close it.
        active.toggleInfoBox();
        ACTIVE_INFO_BOX = this;
      } else {
        // Showing this sliders info, none already open.
        ACTIVE_INFO_BOX = this;
      }

      this.$el.toggleClass('info-box-visible');
      infoBox.animate(
        {
          height: ['toggle', 'easeOutCubic'],
          opacity: ['toggle', 'easeOutQuad'],
        },
        'fast'
      );

      this.initFlowplayer();
      return false;
    },

    /**
     * Closes the box (if open). Used by the collection to force close all info
     * boxes at the same time
     */
    closeInfoBox: function () {
      var infoBox = this.$('.info-wrap');
      if (infoBox.is(':visible')) {
        ACTIVE_INFO_BOX = null;
        this.$el.toggleClass('info-box-visible');
        infoBox.animate(
          {
            height: ['toggle', 'easeOutCubic'],
            opacity: ['toggle', 'easeOutQuad'],
          },
          'fast'
        );
      }
      return false;
    },

    /**
     * Loads the flowplayer when the description of the input element contains a
     * flash movie. The global standalone parameter disables this embedded
     * player.
     */
    initFlowplayer: function () {
      if (!this.model.get('has_flash_movie')) {
        return;
      }
      if (globals.standalone) {
        $('a.player').hide();
      } else {
        flowplayer(
          'a.player',
          {
            src: '/flash/flowplayer-3.2.6.swf',
            wmode: 'opaque',
          },
          {
            clip: { autoPlay: false },
          }
        );
      }
    },

    /**
     * Shows the overlay which allows the user to enter a custom value, and
     * swap between different unit conversions supported by the model.
     */
    showValueSelector: function () {
      if (this.model.get('disabled')) {
        return false;
      }

      this.valueSelector.show();
      return false;
    },

    /**
     * Loads the node details in a fancybox popup
     */
    showNodeDetail: function (e) {
      e.preventDefault();

      var link = e.target.closest('a');
      var title = $(link).data('title');
      var node = $(link).data('node');
      var node_source_url = $(link).data('node_source_url');
      var url = App.scenario.url_path() + '/nodes/' + node;
      var additionalSpecs = buildAdditionalSpecs(this.model.get('additional_specs'));

      link.classList.add('loading');

      $.ajax({
        url: url,
        dataType: 'json',
        headers: App.accessToken.headers(),
        success: function (data) {
          link.classList.remove('loading');

          if (additionalSpecs) {
            data.data = $.extend(true, {}, additionalSpecs, data.data);
          }

          var content = CONVERTER_INFO_T({
            title: title,
            data: specsToList(data.data),
            node_source_url: node_source_url,
            uses_coal_and_wood_pellets: data.uses_coal_and_wood_pellets,
            end_year: App.settings.get('end_year'),
          });
          $.fancybox({
            type: 'html',
            content: content,
            width: 770,
          });
        },
        error: function () {
          link.classList.remove('loading');
        },
      });
    },

    /**
     * Used as the Quinn onCommit callback. Updates the UI.
     *
     * The Quinn onChange event is fired whenever the user moves the slider
     * but not until the onCommit event is fired has the user _finished_.
     * onChange is for updating the UI only, onCommit is where persistance
     * should be. onChange is also fired once when the is initialized.
     */
    quinnOnChange: function (newValue, quinn) {
      // Note that we use quinn.model.value, AND NOT newValue. Grouped inputs
      // may have their values changed during balancing, and this change isn't
      // reflected in the newValue parameter.
      this.setTransientValue(quinn.model.value, true);
    },

    /**
     * Used as the Quinn onCommit callback. Takes care of setting the value
     * back to the model.
     */
    quinnOnCommit: function (newValue) {
      if (!this.model.get('disabled')) {
        this.refreshButtons();
      }

      this.setTransientValue(newValue, true);
      this.updateSublabel(newValue);
      this.model.set({ user_value: newValue });
      this.trigger('change');
    },
  });

  // # ValueSelector ---------------------------------------------------------

  ValueSelector = Backbone.View.extend({
    className: 'value-selector',

    events: {
      'click  button': 'commit',
      'submit form': 'commit',
      'change select': 'changeConversion',
      'keydown input': 'inputKeypress',
    },

    initialize: function (options) {
      this.view = options.view;
      this.uid = _.uniqueId('vse_');

      this.conversions = this.view.conversions;
      this.selectedConversion = this.view.conversion;
      this.lastVisChange = new Date();
    },

    // Rendering ---------------------------------------------------------------

    /**
     * Creates the HTML elements for the value selector, and adds them to the
     * parent element.
     */
    render: function () {
      var $el = this.$el;

      this.model = this.view.quinn.model;

      $el.append(VALUE_SELECTOR_T({ conversions: this.conversions }));
      $el.attr('id', this.uid);

      this.inputEl = this.$('input');
      this.unitEl = this.$('select');
      this.unitNameEl = this.$('.unit');

      this.view.$el.append($el);

      if (this.view.model.get('disabled')) {
        this.inputEl.attr('disabled', true);
      }

      bindValueSelectorBodyEvents();

      return this;
    },

    /**
     * Returns the current value of the input field, converted to the internal
     * representation used by Quinn.
     */
    inputValue: function () {
      var newValue = '' + this.inputEl.val();

      // Some users may enter a comma for decimal places.
      newValue = newValue.replace(/,/, '.');

      if (newValue.length > 0 && ((newValue = Number.parseFloat(newValue)) || newValue === 0)) {
        return this.selectedConversion.toInternal(Number.parseFloat(newValue));
      }

      return 0;
    },

    // ## Event-Handlers -----------------------------------------------------

    /**
     * Triggered when the user clicks the input element <output/> element;
     * sets the selector values only when shown.
     */
    show: function () {
      // Don't show the selector if it was hidden less than 500ms ago (user
      // probably accidentally double-clicked).
      if (new Date() - this.lastVisChange < 500) {
        return false;
      }

      this.lastVisChange = new Date();

      // If this is the first time the selector is being shown, it needs to be
      // rendered first.
      if (!this.inputEl) {
        this.render();
      }

      if (ACTIVE_VALUE_SELECTOR) {
        // Simulate a click to hide the currently open selector.
        $('body').click();
      }

      ACTIVE_VALUE_SELECTOR = this.uid;
      this.selectedConversion = this.view.conversion;

      this.inputEl.val(
        I18n.toNumber(this.model.value, {
          precision: this.selectedConversion.precision,
          delimiter: '',
        })
      );

      this.unitEl.val(this.selectedConversion.uid);
      this.unitNameEl.text(this.selectedConversion.unit);

      this.$el.fadeIn('fast');

      if (!this.inputEl.attr('disabled')) {
        this.inputEl.focus().select();
      }

      // IE.
      this.view.$el.css('z-index', 4000);

      return false;
    },

    /**
     * When the selector is closes, commits the changes back to the view so
     * that it may be updated with the new value and unit conversion.
     */
    commit: function () {
      // Don't do anything if the selector was shown less than 500ms ago (user
      // probably accidentally double-clicked the slider value).
      if (new Date() - this.lastVisChange < 500) {
        return false;
      }

      this.lastVisChange = new Date();

      this.view.conversion = this.selectedConversion;
      this.view.setTransientValue(this.inputValue());
      this.$el.fadeOut('fast');

      this.view.$el.css('z-index', 10);

      ACTIVE_VALUE_SELECTOR = null;

      return false;
    },

    /**
     * Triggered when the user changes the value of the unit conversion
     * drop-down -- changes the <input/> to be converted by the newly selected
     * unit, but does not yet commit the change (if the user closes the
     * selector without clicking "update", the changed unit conversion will
     * not be kept).
     */
    changeConversion: function () {
      var uid = this.unitEl.val();

      this.selectedConversion = _.detect(this.conversions, function (conv) {
        return conv.uid === uid;
      });

      this.inputEl.val(this.selectedConversion.format(this.model.value));
      this.unitNameEl.text(this.selectedConversion.unit);

      if (!this.inputEl.attr('disabled')) {
        this.inputEl.focus().select();
      }

      return false;
    },

    /**
     * Triggered when a user presses a key when the input element is focused.
     * This allows us to track when they press the up or down cursor keys, and
     * step up and down the slider values.
     */
    inputKeypress: function (event) {
      var step = this.model.step,
        newValue;

      // Don't change value if shift is held (commonly used on OS X to select
      // a field value).
      if (!event.shiftKey) {
        if (event.which === 38) {
          // Up key
          newValue = this.inputValue() + step;
        } else if (event.which === 40) {
          // Down key
          newValue = this.inputValue() - step;
        }
      }

      // If an acceptable new value was calculated, set it.
      if (newValue <= this.model.maximum && newValue >= this.model.minimum) {
        this.inputEl.val(this.selectedConversion.format(newValue)).select();
        return false;
      }

      return true;
    },
  });

  // Globals -----------------------------------------------------------------

  window.InputElementView = InputElementView;
})(window);
