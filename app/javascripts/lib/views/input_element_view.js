/**
 * InputElementView
 * Controls the view of a single input element.
 */
var InputElementView = Backbone.View.extend({
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

    _.bindAll(this, 'updateFromModel', 'resetValue', 'toggleInfoBox',
                    'showValueSelector', 'beginStepDown', 'beginStepUp',
                    'quinnOnChange', 'quinnOnCommit', 'commitValueSelection',
                    'abortValueSelection', 'checkMunicipalityNotice',
                    'inputElementInfoBoxShown');

    this.uiMultiplier = 1;

    this.model        = this.options.model;
    this.el           = this.options.el;
    this.precision    = this.__getPrecision();
    this.formatValue  = this.__getFormatter();

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

    // Disable buttons?
    if (this.model.get('disabled')) {
      this.disableButton('reset');
      this.disableButton('decrease');
      this.disableButton('increase');
    }
  },

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
    // onChange, or the displayed value may be updated even though the actual
    // value doesn't change.
    if (this.model.get('share_group')) {
      InputElement.Balancer.
        get(this.model.get('share_group'), { max: 100 }).
        add(this);
    }

    this.quinn.bind('change', this.quinnOnChange);
    this.quinn.bind('commit', this.quinnOnCommit);

    // Need to do this manually, since it needs this.quinn to be set.
    this.quinnOnChange(this.quinn.value, this.quinn);

    return this;
  },

  /**
   * Disables a slider button.
   *
   * The sole argument should be the string "reset", "decrease", or "increase"
   * depending on which button you want to be disabled. All this does is add a
   * disabled class to the button, since the Quinn instance will enforce that
   * the value cannot be changed.
   */
  disableButton: function (buttonName) {
    var buttonElement = this[buttonName + 'Element'];
    buttonElement && buttonElement.addClass('disabled');
  },

  /**
   * Enables a slider button.
   *
   * The sole argument should be the string "reset", "decrease", or "increase"
   * depending on which button you want to be enabled.
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

  // ## Event Handlers

  /**
   * Updates elements of the UI to show the new slider value, but does _not_
   * set the value on the model (which is done later). The value is set on
   * the model as part of the Quinn onCommit callback (see `render`).
   *
   * The `fromSlider` argument indicates whether the new value has come from
   * the Quinn slider, in which case we can trust the value to fit the step,
   * min, and max values, and do not need to run the Quinn callbacks.
   *
   * TODO Buttons need may need to be enabled / disabled, such as when the new
   *      value is the minimum, the decrease button should not be clickable.
   */
  setTransientValue: function (newValue, fromSlider) {
    if (! fromSlider) {
      newValue = this.quinn.setValue(newValue);
    }

    this.valueElement.text(this.formatValue(newValue));

    if (this.valueInputElement) {
      this.valueInputElement.val(this.formatValue(newValue));
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
   * Triggered when the users mouses-down on the decrease button. Reduces the
   * slider value by one step increment. If after HOLD_ACCELERATE ms the button
   * is still being held down, the slider value will continue to be decreased
   * until either the minimum value is reached, or the user lifts the button.
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
   * Shows the overlay which allows the user to enter a custom value, and swap
   * between different unit conversions supported by the model.
   *
   * This is a bit messy.
   *
   * TODO Move to an Underscore template?
   */
  showValueSelector: function (event) {
    // If the value selector hasn't been shown previously, render it now...
    if (! this.valueSelectorElement) {
      var units   = this.model.get('conversions'),
          uLength = units.length,
          form, i;

      form = $('<form action=""></form>');

      this.valueSelectorElement = $('<div class="value-selector"></div>');
      this.valueInputElement    = $('<input type="text"></input>');
      this.valueUnitElement     = $('<select></select>');

      this.valueSelectorElement.attr('id', _.uniqueId('vse_'));

      this.valueUnitElement.append(
        $('<option></options').text('Default Unit').attr('value', -1));

      // Add unit types to the select.
      for (i = 0; i < uLength; i++) {
        this.valueUnitElement.append(
          $('<option></options').text(units[i].name).attr('value', i)
        );
      }

      form.append(this.valueInputElement);

      if (i > 0) {
        // Only show the unit selection if there were any.
        form.append(this.valueUnitElement);
      }

      form.append($('<button>Update</button>'));

      this.el.append(this.valueSelectorElement.append(form));

      if (InputElementView.BODY_HIDE_EVENT === false) {
        $('body').click(this.abortValueSelection);
        InputElementView.BODY_HIDE_EVENT = true;
      }
    }

    this.valueInputElement.val(this.quinn.value);
    this.valueSelectorElement.fadeIn('fast');
    this.valueInputElement.focus();

    event.stopPropagation();
    return false;
  },

  /**
   * Commits the new settings selected by the user from the value selector and
   * updates the UI.
   */
  commitValueSelection: function (event) {
    var newValue = this.valueInputElement.val();

    if (newValue.length > 0) {
      newValue = parseFloat(newValue);

      if (! _.isNaN(newValue)) {
        this.quinn.setValue(newValue * ( 1 / this.multiplier ));
      }
    }

    this.valueSelectorElement.fadeOut('fast');

    event.stopPropagation();
    return false;
  },

  /**
   * Closes the value selector without changing the value.
   */
  abortValueSelection: function (event) {
    var $target = $(event.target),
        vseId   = this.valueSelectorElement.attr('id');

    if ($target.attr('id') !== vseId &&
        ! $target.parents('#' + vseId).length) {

      // Hide if the element clicked was not the value selection elemnt, or a
      // child of the selection element.
      this.valueSelectorElement.fadeOut('fast');
    }
  },

  /**
   * Triggered when the user changes the unit type, tweaking the display of
   * values to use a different multiplier.
   */
  changeValueMultiplier: function (event) {
    var index = parseInt($(event.currentTarget).val(), 10);

    if (index === -1) {
      this.uiMultiplier = 1;
    } else {
      this.uiMultiplier = this.model.get('conversions')[index].multiplier;
    }

    this.formatValue = this.__getFormatter();
    this.setTransientValue(this.quinn.value, true);

    event.stopPropagation();
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

      if (newValue === this.quinn.range[0]) {
        this.disableButton('decrease');
        this.enableButton('increase');
      } else if (newValue === this.quinn.range[1]) {
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

  // ## Pseudo-Private Methods

  /**
   * Determines how many decimal places should be used when formatting the
   * slider value for display.
   */
  __getPrecision: function () {
    var mStep     = this.model.get('step_value'),
        precision = 0;

    if (_.isNumber(mStep)) {
        precision = mStep.toString().split('.');
        precision = precision[1] ? precision[1].length : 0
    }

    return precision;
  },

  /**
   * Used to format values in the output element. Memoized as
   * this.formatValue.
   */
  __getFormatter: function () {
    var precision  = this.precision,
        multiplier = this.uiMultiplier,
        mUnit      = this.model.get('unit'),
        unit       = '';

    if (_.isString(mUnit)) {
      switch (mUnit) {
        case "%":
        case "#":
        case "MW":
        case "km2":
        case "km":
        case "x":
          unit = ' ' + mUnit;
          break;
        // Add custom units here...
      }
    }

    return function (value) {
      return (value * multiplier).toFixed(precision) + unit;
    };
  },
});

// The number of milliseconds which pass before stepping up and down values
// should begin being repeated.
InputElementView.HOLD_ACCELERATE = 125;

// Tracks whether the body has been assigned an event to hide input selection
// boxes when the user clicks outside them.
InputElementView.BODY_HIDE_EVENT = false;
