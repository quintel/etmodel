(function (window) {
  'use strict';

  var BODY_HIDE_EVENT, ACTIVE_VALUE_SELECTOR,
      INPUT_ELEMENT_T, VALUE_SELECTOR_T,
      HOLD_DELAY, HOLD_DURATION, HOLD_FPS,
      IS_IE_LTE_EIGHT,

      floatPrecision, conversionsFromModel,
      abortValueSelection, bindValueSelectorBodyEvents,

      InputElementView, ValueSelector;

  // # Constants -------------------------------------------------------------

  // The number of milliseconds which pass before stepping up and down values
  // should begin being repeated.
  HOLD_DELAY    = 500;
  HOLD_DURATION = 2000;
  HOLD_FPS      = 60;

  // Tracks whether the body has been assigned an event to hide input
  // selection boxes when the user clicks outside them.
  BODY_HIDE_EVENT = false;

  // Holds the ID of the currently displayed value selector so it can be
  // hidden if the user clicks outside of it.
  ACTIVE_VALUE_SELECTOR = null;

  // Detect IE8 so that we can use the custom PNG when disabled, since it
  // managed to screw up opacity so spectacularly.
  IS_IE_LTE_EIGHT = ($.browser.msie && $.browser.version <= 8);

  // Templates.
  $(function () {
    INPUT_ELEMENT_T  = _.template($('#input-element-template').html());
    VALUE_SELECTOR_T = _.template($('#value-selector-template').html());
  });

  /**
   * Given an integer or float, returns how many decimal places are present,
   * so that other numbers can be displayed with the same precisioin with
   * toFixed().
   */
  floatPrecision = function (value) {
    var precision = 0;

    if (_.isNumber(value)) {
      precision = value.toString().split('.');
      precision = precision[1] ? precision[1].length : 0;
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
        modelConvs  = model.get('conversions'),
        mPrecision  = floatPrecision(model.get('step_value')),
        cKey;

    conversions.push(new UnitConversion({
      name:       I18n.t('unit_conversions.default'),
      unit:       model.get('unit'),
      multiplier: 1
    }, mPrecision));

    for (cKey in modelConvs) {
      if (modelConvs.hasOwnProperty(cKey)) {
        conversions.push(new UnitConversion({
          name:       I18n.t('unit_conversions.' + cKey),
          unit:       modelConvs[cKey][0],
          multiplier: modelConvs[cKey][1]
        }, mPrecision));
      }
    }

    return _.sortBy(conversions, function (c) { return c.name; });
  };

  /**
   * Closes the currently open value selector without changing the value.
   */
  abortValueSelection = function (event) {
    if (! ACTIVE_VALUE_SELECTOR) {
      return true;
    }

    // Hide if the element clicked was not the value selection elemnt, or a
    // child of the selection element.
    if (! $(event.target).closest('#' + ACTIVE_VALUE_SELECTOR).get(0)) {
      $('#' + ACTIVE_VALUE_SELECTOR).fadeOut('fast').
        parent('.new-input-slider').css('z-index', 10);

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

    $body
      .click(abortValueSelection)
      .keyup(function (event) { if (event.which === 27) { $body.click(); } });

    BODY_HIDE_EVENT = true;
  };

  // # UnitConversion --------------------------------------------------------

  function UnitConversion (data, originalPrecision) {
    this.name       = data.name;
    this.multiplier = data.multiplier;
    this.unit       = data.unit;
    this.precision  = originalPrecision + floatPrecision(this.multiplier);
    this.uid        = _.uniqueId('uconv_');
  }

  /**
   * Given the slider value, formats the value taking into account the
   * conversion multiplier and precision. Returns a string.
   *
   * For example:
   *
   *    u.format(2) # => "4.2"
   */
  UnitConversion.prototype.format = function (value) {
    return (value * (this.multiplier || 1)).toFixed(this.precision);
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
    return $('<option></option>').val(this.uid).text(this.name);
  };

  // # InputElementView ------------------------------------------------------

  InputElementView = Backbone.View.extend({
    events: {
      'click     .reset':      'resetValue',
      'mousedown .decrease':   'beginStepDown',
      'mousedown .increase':   'beginStepUp',
      'click     .show-info':  'toggleInfoBox',
      'click     .output':     'showValueSelector'
    },

    initialize: function (options) {
      _.bindAll(
         this,
        'updateFromModel',
        'quinnOnChange',
        'quinnOnCommit',
        'checkMunicipalityNotice',
        'inputElementInfoBoxShown'
      );

      this.conversions   = conversionsFromModel(this.model);
      this.conversion    = this.conversions[0];
      this.valueSelector = new ValueSelector({ view: this });
      this.initialValue  = this.model.get('user_value');

      // Keeps track of intervals used to repeat stepDown and stepUp
      // operations when the user holds down the mouse button.
      this.incrementInterval = null;

      this.model.bind('change', this.updateFromModel);

      // make the toggle red if it's semi unadaptable and in a municipality.
      if (App.municipalityController.isMunicipality() &&
                  this.model.get("semi_unadaptable")) {

        // TODO Needs a custom Quinn sprite to do this on the new slider.
        // this.sliderView.slider.toggleButton.element.addClass('municipality-toggle');
      }

      this.render();
    },

    // ## Rendering ----------------------------------------------------------

    /**
     * Creates the HTML elements used to display the slider.
     */
    render: function () {

      // TEMPLATING.

      this.el.addClass('new-input-slider').html(
        INPUT_ELEMENT_T({
          name: this.model.get('translated_name'),
          info: this.el.find('.info-box .text').text()
        })
      );

      this.resetElement    = this.$('.reset');
      this.decreaseElement = this.$('.decrease');
      this.increaseElement = this.$('.increase');
      this.valueElement    = this.$('.output');

      // INITIALIZATION.

      // new $.Quinn is an alternative to $(...).quinn(), and allows us to
      // easily keep hold of the Quinn instance.
      this.quinn = new $.Quinn(this.$('.quinn'), {
        range:    [ this.model.get('min_value'),
                    this.model.get('max_value') ],

        value:      this.initialValue,
        step:       this.model.get('step_value'),
        disable:    this.model.get('disabled'),

        // Disable effects on sliders which are part of a group, since the
        // animation can look a little jarring.
        effects:  ! this.model.get('share_group'),

        // No opacity for IE <= 8.
        disabledOpacity: (IS_IE_LTE_EIGHT ? 1.0 : 0.5)
      });

      // The group onChange needs to be bound before the InputElementView
      // onChange, or the displayed value may be updated even though the
      // actual value doesn't change.
      if (this.model.get('share_group')) {
        InputElement.Balancer.
          get(this.model.get('share_group'), { max: 100 }).
          add(this);
      }

      this.quinn.bind('change', this.quinnOnChange);
      this.quinn.bind('commit', this.quinnOnCommit);

      // Need to do this manually, since it needs this.quinn to be set.
      this.quinnOnChange(this.quinn.value, this.quinn);

      // Disable buttons?
      if (this.model.get('disabled')) {
        this.disableButton('reset');
        this.disableButton('decrease');
        this.disableButton('increase');
      } else {
        this.refreshButtons();
      }

      return this;
    },

    /**
     * Disable min / max button if the input is set to it's lowest or highest
     * permitted value, and the reset button if the current slider value is
     * the original value.
     */
    refreshButtons: function () {
      var value = this.quinn.value;

      if (value === this.quinn.selectable[0]) {
        this.disableButton('decrease');
        this.enableButton('increase');
      } else if (value === this.quinn.selectable[1]) {
        this.disableButton('increase');
        this.enableButton('decrease');
      } else {
        this.enableButton('decrease');
        this.enableButton('increase');
      }

      if (value === this.initialValue) {
        this.disableButton('reset');
      } else {
        this.enableButton('reset');
      }
    },

    // ## Instance Methods ---------------------------------------------------

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
     * This checks if the municipality message has been shown. It is has not
     * been shown, show it!
     */
    checkMunicipalityNotice: function () {
      if (this.model.get('semi_unadaptable') &&
            App.municipalityController.showMessage()) {

        App.municipalityController.showMunicipalityMessage();
      }
    },

    /**
     * Is called when something in the constraint model changed.
     * @override
     */
    updateFromModel: function () {
      if (! this.disableUpdate) {
        return;
      }

      this.quinn.setValue(this.model.get('user_value'));

      return false;
    },

    /**
     * Is called when then infobox is clicked.
     * @override
     */
    inputElementInfoBoxShown: function () {
      this.trigger('show');

      if (this.model.get('has_flash_movie')) {
        flowplayer('a.player', '/flash/flowplayer-3.2.6.swf');
      }
    },

    // ## Event Handlers -----------------------------------------------------

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
      if (! fromSlider) {
        newValue = this.quinn.setValue(newValue);
      }

      this.valueElement.text(this.conversion.formatWithUnit(newValue));

      return newValue;
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
      this.performStepping(this.quinn.selectable[0]);
    },

    /**
     * Triggered when the users mouses-down on the increase button. Increases
     * the slider value by one step increment. If after HOLD_DELAY ms the
     * button is still being held down, the slider value will continue to be
     * decreased until either the minimum value is reached, or the user lifts
     * the button.
     */
    beginStepUp: function () {
      this.performStepping(this.quinn.selectable[1]);
    },

    /**
     * Sets up events, intervals and timeouts when the user clicks the
     * increase or decrease buttons, such that the value continues to be
     * adjusted so long as they hold the mouse button.
     */
    performStepping: function (targetValue) {
      var initialValue   = this.quinn.value,
          duration       = HOLD_DURATION / (1000 / HOLD_FPS),
          isIncreasing   = (targetValue > initialValue),
          stepIterations = 0,

          delta          = this.quinn.selectable[1] -
                           this.quinn.selectable[0],

          progress, timeoutId, intervalId, intervalFunc, onFinish;

      // --

      if (! this.quinn.__willChange()) {
        return false;
      }

      if (isIncreasing) {
        this.quinn.__setValue(initialValue + this.quinn.options.step);
      } else {
        this.quinn.__setValue(initialValue - this.quinn.options.step);
      }

      initialValue = this.quinn.value;

      // Reduce how long it takes to move the slider to the target value by
      // how close it is. For example, if moving from 0% to 100%, the movement
      // will take the full three seconds. If moving from 50% to 100%, it will
      // take 1.5 seconds, etc...
      duration *= Math.abs((targetValue - initialValue) / delta);

      // Interval function is what happens every 10 ms, where the slider value
      // is changed while the user continues to hold their mouse-button.
      intervalFunc = _.bind(function () {
        progress = $.easing.easeInCubic(
          null,
          stepIterations++, // current time
          0, 1,             // start / finish value
          duration          // total number of iterations
        );

        this.quinn.__setValue(
          initialValue + ((targetValue - initialValue) * progress));

        if (this.quinn.value === targetValue) {
          // We've reached the target value, so stop trying to move further.
          window.clearInterval(intervalId);
        }
      }, this);

      // Set a timeout so that after HOLD_DELAY seconds, the slider value will
      // continue to be changed so long as the user holds the mouse button.
      timeoutId = window.setTimeout(_.bind(function () {
        intervalId = window.setInterval(intervalFunc, 1000 / HOLD_FPS);
      }, this), HOLD_DELAY);

      // Executed when the user lifts the mouse button; commits the new value.
      onFinish = _.bind(function () {
        $('body').unbind('mouseup.stepaccel');

        this.quinn.__hasChanged();

        window.clearTimeout(timeoutId);
        window.clearInterval(intervalId);

        timeoutId  = null;
        intervalId = null;
      }, this);

      $('body').bind('mouseup.stepaccel', onFinish);
    },

    /**
     * Toggles display of the slider information box.
     */
    toggleInfoBox: function () {
      this.el.toggleClass('info-box-visible');

      this.$('.info-wrap').animate({
        height:  ['toggle', 'easeOutCubic'],
        opacity: ['toggle', 'easeOutQuad']
      }, 'fast');

      return false;
    },

    /**
     * Shows the overlay which allows the user to enter a custom value, and
     * swap between different unit conversions supported by the model.
     */
    showValueSelector: function (event) {
      this.valueSelector.show();
      return false;
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
      this.setTransientValue(newValue, true);
    },

    /**
     * Used as the Quinn onCommit callback. Takes care of setting the value
     * back to the model.
     */
    quinnOnCommit: function (newValue, quinn) {
      if (! this.model.get('disabled')) {
        this.refreshButtons();
      }

      this.setTransientValue(newValue, true);
      this.model.set({ user_value: newValue });
      this.checkMunicipalityNotice();
      this.trigger('change');
    }
  });

  // # ValueSelector ---------------------------------------------------------

  ValueSelector = Backbone.View.extend({
    className: 'value-selector',

    events: {
      'click  button': 'commit',
      'submit form':   'commit',
      'change select': 'changeConversion',
      'keydown input': 'inputKeypress'
    },

    initialize: function (options) {
      this.view = options.view;
      this.uid  = _.uniqueId('vse_');

      this.conversions        = this.view.conversions;
      this.selectedConversion = this.view.conversion;
    },

    // ## Rendering ----------------------------------------------------------

    /**
     * Creates the HTML elements for the value selector, and adds them to the
     * parent element.
     */
    render: function () {
      var $el = $(this.el);

      $el.append( VALUE_SELECTOR_T({ conversions: this.conversions }) );
      $el.attr('id', this.uid);

      this.inputEl    = this.$('input');
      this.unitEl     = this.$('select');
      this.unitNameEl = this.$('.unit');

      this.view.el.append($el);

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
      var newValue = this.inputEl.val();

      if (newValue.length > 0 &&
              ((newValue = parseFloat(newValue)) || newValue === 0)) {

        return this.selectedConversion.toInternal(parseFloat(newValue));
      }

      return 0;
    },

    // ## Event-Handlers -----------------------------------------------------

    /**
     * Triggered when the user clicks the input element <output/> element;
     * sets the selector values only when shown.
     */
    show: function () {
      // If this is the first time the selector is being shown, it needs to be
      // rendered first.
      if (! this.inputEl) {
        this.render();
      }

      if (ACTIVE_VALUE_SELECTOR) {
        // Simulate a click to hide the currently open selector.
        $('body').click();
      }

      ACTIVE_VALUE_SELECTOR   = this.uid;
      this.selectedConversion = this.view.conversion;

      this.inputEl.val(this.selectedConversion.format(this.view.quinn.value));
      this.unitEl.val(this.selectedConversion.uid);
      this.unitNameEl.text(this.selectedConversion.unit);

      $(this.el).fadeIn('fast');

      if (! this.inputEl.attr('disabled')) {
        this.inputEl.focus().select();
      }

      // IE.
      this.view.el.css('z-index', 4000);

      return false;
    },

    /**
     * When the selector is closes, commits the changes back to the view so
     * that it may be updated with the new value and unit conversion.
     */
    commit: function () {
      this.view.conversion = this.selectedConversion;
      this.view.setTransientValue(this.inputValue());
      $(this.el).fadeOut('fast');

      this.view.el.css('z-index', 10);

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

      this.inputEl.val(this.selectedConversion.format(this.view.quinn.value));
      this.unitNameEl.text(this.selectedConversion.unit);

      if (! this.inputEl.attr('disabled')) {
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
      var step = this.view.quinn.options.step,
          newValue;

      // Don't change value if shift is held (commonly used on OS X to select
      // a field value).
      if (! event.shiftKey) {
        if (event.which === 38) { // Up key
          newValue = this.inputValue() + step;
        } else if (event.which === 40) { // Down key
          newValue = this.inputValue() - step;
        }
      }

      // If an acceptable new value was calculated, set it.
      if (newValue <= this.view.quinn.selectable[1] &&
          newValue >= this.view.quinn.selectable[0]) {

        this.inputEl.val(this.selectedConversion.format(newValue)).select();
        return false;
      }

      return true;
    }
  });

  // Globals -----------------------------------------------------------------

  window.InputElementView = InputElementView;

})(window);
