(function (window) {

  var HOLD_ACCELERATE, BODY_HIDE_EVENT, ACTIVE_VALUE_SELECTOR,
      floatPrecision, conversionsFromModel, abortValueSelection,
      UnitConversion, InputElementView;

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
        precision = precision[1] ? precision[1].length : 0
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
   *    u.value(2) # => "4.2"
   */
  UnitConversion.prototype.value = function (value) {
    return (value * (this.multiplier || 1)).toFixed(this.precision);
  };

  /**
   * Given the slider value, formats it taking into account the multiplier and
   * precision, and appends the unit suffix, such as would be displayed in the
   * <output/> element.
   *
   * For example:
   *
   *    u.valueWithUnit(2) # => "4.2 GW"
   */
  UnitConversion.prototype.valueWithUnit = function (value) {
    if (this.unit && this.unit.length > 0) {
      return this.value(value) + ' ' + this.unit;
    }

    return this.value(value);
  };

  /**
   * Given a converted value (such as one entered in the value input element,
   * converts it back to the value which should be used internally by Quinn to
   * represent the value.
   *
   * For example:
   *
   *    u.formattedToInternal(4.2) # => 2.0
   */
  UnitConversion.prototype.formattedToInternal = function (formatted) {
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
      'click      output':                'showValueSelector',
      'click     .value-selector button': 'commitValueSelection',
      'submit    .value-selector form':   'commitValueSelection',
      'change    .value-selector select': 'changeValueMultiplier'
    },

    initialize: function (options) {
      Backbone.View.prototype.initialize.call(this, options);

      _.bindAll(
         this,
        'updateFromModel',
        'resetValue',
        'toggleInfoBox',
        'showValueSelector',
        'beginStepDown',
        'beginStepUp',
        'quinnOnChange',
        'quinnOnCommit',
        'commitValueSelection',
        'checkMunicipalityNotice',
        'inputElementInfoBoxShown'
      )

      this.model       = this.options.model;
      this.el          = this.options.el;
      this.conversions = conversionsFromModel(this.model);
      this.conversion  = this.conversions[0];

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
        effects:  ! this.model.get('share_group'),
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
      }

      return this;
    },

    /**
     * Creates HTML for the value selector (the overlay which pops up when a
     * user clicks on the slider value.
     */
    renderValueSelector: function () {
      var cLength = this.conversions.length, form, i;

      form = $('<form action=""></form>');

      this.valueSelectorElement = $('<div class="value-selector"></div>');
      this.valueSelectorElement.attr('id', _.uniqueId('vse_'));

      this.valueInputElement    = $('<input type="text"></input>');
      this.valueUnitElement     = $('<select></select>');

      // Add unit types to the select.
      for (i = 0; i < cLength; i++) {
        this.valueUnitElement.append(this.conversions[i].toOptionEl());
      }

      form.append(this.valueInputElement);

      if (i > 0) {
        // Only show the unit selection if there were any.
        form.append(this.valueUnitElement);
      }

      form.append($('<button>Update</button>'));

      this.el.append(this.valueSelectorElement.append(form));

      if (BODY_HIDE_EVENT === false) {
        $('body').click(abortValueSelection);
        BODY_HIDE_EVENT = true;
      }

      return this;
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
    checkMunicipalityNotice:function () {
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

      this.valueElement.text(this.conversion.valueWithUnit(newValue));

      if (this.valueInputElement) {
        this.valueInputElement.val(this.conversion.value(newValue));
      }

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
      // If the value selector hasn't been shown previously, render it now...
      if (! this.valueSelectorElement) {
        this.renderValueSelector();
      }

      if (ACTIVE_VALUE_SELECTOR) {
        // Simulate a click to hide the currently open selector.
        $('body').click();
      }

      ACTIVE_VALUE_SELECTOR = this.valueSelectorElement.attr('id');

      this.valueInputElement.val(this.conversion.value(this.quinn.value));
      this.valueSelectorElement.fadeIn('fast');
      this.valueInputElement.focus();

      return false;
    },

    /**
     * Commits the new settings selected by the user from the value selector
     * and updates the UI.
     */
    commitValueSelection: function (event) {
      var newValue = this.valueInputElement.val();

      if (newValue.length > 0 && !! ( newValue = parseFloat(newValue) )) {
        this.quinn.setValue(this.conversion.formattedToInternal(newValue));
      }

      this.valueSelectorElement.fadeOut('fast');
      ACTIVE_VALUE_SELECTOR = null;

      return false;
    },

    /**
     * Triggered when the user changes the unit type, tweaking the display of
     * values to use a different multiplier.
     */
    changeValueMultiplier: function (event) {
      var uid = $(event.currentTarget).val();

      this.conversion = _.detect(this.conversions, function (conv) {
        return conv.uid === uid;
      });

      this.setTransientValue(this.quinn.value, true);

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
        // Disable min / max button if the input is set to it's lowest or
        // highest permitted value, and the reset button if the current
        // slider value is the original value.

        if (newValue === this.quinn.selectable[0]) {
          this.disableButton('decrease');
          this.enableButton('increase');
        } else if (newValue === this.quinn.selectable[1]) {
          this.disableButton('increase');
          this.enableButton('decrease');
        } else {
          this.enableButton('decrease');
          this.enableButton('increase');
        }

        if (newValue === this.model.get('start_value')) {
          this.disableButton('reset');
        } else {
          this.enableButton('reset');
        }
      }

      this.setTransientValue(newValue, true);
      this.model.set({ user_value: newValue });
      this.checkMunicipalityNotice();
      this.trigger('change');
    },

  });

  // Globals -----------------------------------------------------------------

  window.InputElementView = InputElementView;

})(window);
