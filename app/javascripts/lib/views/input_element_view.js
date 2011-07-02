(function (window) {
  'use strict';

  var HOLD_ACCELERATE, BODY_HIDE_EVENT, ACTIVE_VALUE_SELECTOR,
      floatPrecision, conversionsFromModel, abortValueSelection,
      InputElementView, ValueSelector;

  // # Constants -------------------------------------------------------------

  // The number of milliseconds which pass before stepping up and down values
  // should begin being repeated.
  HOLD_ACCELERATE = 125;

  // Tracks whether the body has been assigned an event to hide input
  // selection boxes when the user clicks outside them.
  BODY_HIDE_EVENT = false;

  // Holds the ID of the currently displayed value selector so it can be
  // hidden if the user clicks outside of it.
  ACTIVE_VALUE_SELECTOR = null;

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
   */
  conversionsFromModel = function (model) {
    var conversions = [],
        modelConvs  = model.get('conversions'),
        cLength     = modelConvs.length,
        mPrecision  = floatPrecision(model.get('step_value')),
        i;

    conversions.push(new UnitConversion({
      name:      'Default Unit',
      unit:       model.get('unit'),
      multiplier: 1
    }, mPrecision));

    for (i = 0; i < cLength; i++) {
      conversions.push(new UnitConversion(modelConvs[i], mPrecision));
    }

    return conversions;
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
      $('#' + ACTIVE_VALUE_SELECTOR).fadeOut('fast');
      ACTIVE_VALUE_SELECTOR = null;
    }
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
      'click     .reset':                 'resetValue',
      'mousedown .decrease':              'beginStepDown',
      'mousedown .increase':              'beginStepUp',
      'click     .show-info':             'toggleInfoBox',
      'click      output':                'showValueSelector'
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
      var quinnElement   = $('<div class="quinn"></div>'),
          wrapperElement = $('<div class="slider-controls"></div>'),

          // Need to keep hold of this to add the text to the new info box...
          description = this.el.find('.info-box .text').text(),

          quinnOnChange, quinnOnComplete;

      // TEMPLATING.

      // Start by removing the contents of the existing element, so that we
      // may add our own.
      this.el.empty();
      this.el.addClass('new-input-slider');

      // The label.
      wrapperElement.append(
        $('<label><label>').text(this.model.get('translated_name')));

      // Reset and decrease-value buttons.
      this.resetElement = $('<div class="reset"></div>');
      wrapperElement.append(this.resetElement);

      this.decreaseElement = $('<div class="decrease"></div>');
      wrapperElement.append(this.decreaseElement);

      // Holds the Quinn slider widget.
      wrapperElement.append(quinnElement);

      // Increase-value button.
      this.increaseElement = $('<div class="increase"></div>');
      wrapperElement.append(this.increaseElement);

      // Displays the current value to the user.
      this.valueElement = $('<output></output>');
      wrapperElement.append(this.valueElement);

      // The help / info button.
      wrapperElement.append('<div class="show-info"></div>');

      // Finally, the help / info box itself.
      this.el.append(wrapperElement);
      this.el.append($('<div class="info"></div>').text(description));

      // INITIALIZATION.

      // new $.Quinn is an alternative to $(...).quinn(), and allows us to
      // easily keep hold of the Quinn instance.
      this.quinn = new $.Quinn(quinnElement, {
        range:    [ this.model.get('min_value'),
                    this.model.get('max_value') ],

        value:      this.model.get('user_value'),
        step:       this.model.get('step_value'),
        disable:    this.model.get('disabled'),

        // Disable effects on sliders which are part of a group, since the
        // animation can look a little jarring.
        effects:  ! this.model.get('share_group')
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

      if (value === this.model.get('start_value')) {
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
     *
     * TODO Buttons need may need to be enabled / disabled, such as when the
     *      new value is the minimum, the decrease button should not be
     *      clickable.
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
    resetValue: function () {
      this.quinn.setValue(this.model.get('start_value'));
    },

    /**
     * Triggered when the users mouses-down on the decrease button. Reduces
     * the slider value by one step increment. If after HOLD_ACCELERATE ms the
     * button is still being held down, the slider value will continue to be
     * decreased until either the minimum value is reached, or the user lifts
     * the button.
     */
    beginStepDown: function () {
      this.quinn.stepDown();
    },

    /**
     * Triggered when the users mouses-down on the increase button. Increases
     * the slider value by one step increment. If after HOLD_ACCELERATE ms the
     * button is still being held down, the slider value will continue to be
     * decreased until either the minimum value is reached, or the user lifts
     * the button.
     */
    beginStepUp: function () {
      this.quinn.stepUp();
    },

    /**
     * Toggles display of the slider information box.
     */
    toggleInfoBox: function () {
      this.el.toggleClass('info-box-visible');
    },

    /**
     * Shows the overlay which allows the user to enter a custom value, and
     * swap between different unit conversions supported by the model.
     *
     * This is a bit messy.
     *
     * TODO Move to an Underscore template?
     */
    showValueSelector: function (event) {
      if (! this.model.get('disabled')) {
        this.valueSelector.show();
      }

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
      var cLength = this.conversions.length,
          form    = $('<form action=""></form>'),
          conv    = $('<div class="conversion"></div>'),
          i;

      this.inputEl    = $('<input type="text"></input>');
      this.unitEl     = $('<select></select>');
      this.unitNameEl = $('<span class="unit"></span>');

      form.append(this.inputEl);

      if (this.conversions.length > 1) {
        // The view always has at least one unit conversion (the default), so
        // we only show the unit conversion <select/> if there are others
        // available.

        // Add unit types to the select.
        for (i = 0; i < cLength; i++) {
          this.unitEl.append(this.conversions[i].toOptionEl());
        }

        conv.append(this.unitNameEl);
        conv.append(this.unitEl);

        form.append(conv);
      }

      if (BODY_HIDE_EVENT === false) {
        $('body').click(abortValueSelection);
        BODY_HIDE_EVENT = true;
      }

      form.append($('<button>Update</button>'));

      $(this.el).attr('id', this.uid);
      $(this.view.el).append($(this.el).append(form));

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
      this.inputEl.focus().select();

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

      this.inputEl.focus().select();

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
