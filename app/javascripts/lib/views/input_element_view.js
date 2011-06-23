/**
 * InputElementView
 * Controls the view of a single input element.
 */
var InputElementView = Backbone.View.extend({
  initialize: function (options) {
    _.bindAll(this, 'updateHandler', 'resetValue',
                    'beginStepDown', 'beginStepUp', 'toggleInfoBox');

    this.model   = this.options.model;
    this.element = this.options.element;

    // Keeps track of intervals used to repeat stepDown and stepUp
    // operations when the user holds down the mouse button.
    this.incrementInterval = null;

    this.model.bind('change', this.updateHandler);

    var lSliderOptions = {
      'reset_value': this.model.get('start_value'),
      'value':       this.model.get('user_value'),
      'step_value':  this.model.get('step_value'),
      'min_value':   this.model.get('min_value'),
      'max_value':   this.model.get('max_value'),
      'name':        this.model.get('translated_name'),
      'share_group': this.model.get('share_group'),
      'disabled':    this.model.get('disabled'),
      'fixed':       this.model.get("input_element_type") == "fixed" ||
                     this.model.get("input_element_type") == "fixed_share",
      'formatter':   this.getFormatter(),
      'precision':   this.getPrecision(),
      'element':     this.element,
      'infoBox':     { 'disableDataBox': true }
    };

    this.sliderView = new AdvancedSliderView(lSliderOptions);

    this.set_full_label(this.model.get('label'));

    // make the toggle red if it's semi unadaptable and in a municipality.
    if (App.municipalityController.isMunicipality() &&
                this.model.get("semi_unadaptable")) {

      this.sliderView.slider.toggleButton.element.addClass('municipality-toggle');
    }

    this.render();
    this.initEventListeners();
  },

  /**
   * Creates the HTML elements used to display the slider.
   */
  render: function () {
    var quinnElement = $('<div class="quinn"></div>'),

        // Need to keep hold of this to add the text to the new info box...
        description = this.element.find('.info-box .text').text(),

        quinnOnChange, quinnOnComplete;

    // TEMPLATING.

    // Start by removing the contents of the existing element, so that we
    // may add our own.
    this.element.empty();
    this.element.addClass('new-input-slider');

    // The label.
    this.element.append(
      $('<label><label>').text(this.model.get('translated_name')));

    // Reset and decrease-value buttons.
    this.element.append('<div class="reset"></div>');
    this.element.append('<div class="decrease"></div>');

    // Holds the Quinn slider widget.
    this.element.append(quinnElement);

    // Increase-value button.
    this.element.append('<div class="increase"></div>');

    // Displays the current value to the user.
    this.valueElement = $('<div class="value"></div>');
    this.element.append(this.valueElement);

    // The help / info button.
    this.element.append('<div class="show-info"></div>');

    // Finally, the help / info box itself.
    this.element.append($('<div class="info"></div>').text(description));

    // INITIALIZATION.

    // The Quinn onChange event is fired whenever the user moves the slider
    // but not until the onComplete event is fired has the user _finished_.
    // onChange is for updating the UI only, onComplete is where persistance
    // should be. onChange is also fired once when the is initialized.
    quinnOnChange = _.bind(function (newValue, quinn) {
      this.setTransientValue(newValue, true);
    }, this);

    // Fired once the user has finished editing the value.
    quinnOnComplete = _.bind(function (newValue, quinn) {
      this.model.set({ user_value: newValue });
    }, this);

    // new $.Quinn is an alternative to $(...).quinn(), and allows us to
    // easily keep hold of the Quinn instance.
    this.quinn = new $.Quinn(quinnElement, {
      range:    [ this.model.get('min_value'),
                  this.model.get('max_value') ],

      value:      this.model.get('user_value'),
      step:       this.model.get('step_value'),
      disable:    this.model.get('disabled'),

      // Callbacks.
      onSetup:    quinnOnChange,
      onChange:   quinnOnChange,
      onComplete: quinnOnComplete
    });

    // EVENTS.

    this.element.
      delegate('.reset',     'click',     this.resetValue).
      delegate('.decrease',  'mousedown', this.beginStepDown).
      delegate('.increase',  'mousedown', this.beginStepUp).
      delegate('.show-info', 'click',     this.toggleInfoBox);

    return this;
  },

  set_full_label: function (text) {
    this.element.find(".label").html(text);
  },

  /**
   * Init event listeners.
   */
  initEventListeners: function () {
    this.sliderView.slider.sliderVO.bind('update', $.proxy(function() {
      this.model.set({ 'user_value': this.sliderView.slider.getValue() });
    }, this));

    this.sliderView.getInfoBox().bind(
      'show', $.proxy(this.handleInputElementInfoBoxShowed, this));

    this.sliderView.bind(
      'change', $.proxy(this.checkMunicipalityNotice, this));

    this.sliderView.slider.bind(
      'change', $.proxy(this.handleSliderUpdate, this));
  },

  /**
   * Returns the number of decimal places used when formatting the value
   * shown for the input element.
   */
  getPrecision: function () {
    var lPrecisionStr = this.model.get('step_value').toString() + '';
    lPrecision = lPrecisionStr.replace('.', '').length - 1;
    return lPrecision;
  },

  /**
   * Returns a formatter on basis of the step_value.
   */
  getFormatter: function () {
    switch (this.model.get('unit')) {
      case "%":
        return SliderFormatter.numberWithSymbolFactory('%');
      case "#":
        return SliderFormatter.numberWithSymbolFactory('#');
      case "MW":
        return SliderFormatter.numberWithSymbolFactory('MW');
      case "km2":
        return SliderFormatter.numberWithSymbolFactory('km2');
      case "km":
        return SliderFormatter.numberWithSymbolFactory('km');
      case "x":
        return SliderFormatter.numberWithSymbolFactory('x');

      default:
        return null;
    }
  },

  /**
   * When the user does something on a slider this handler is invoked.
   */
  handleSliderUpdate: function () {
    this.disableUpdate = true;

    this.model.set({ 'user_value': this.sliderView.slider.getValue() });

    this.sliderView.slider.setValue(
      this.model.get('user_value'), { noEvent: true });

    this.disableUpdate = false;
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
  updateHandler: function () {
    if (this.disableUpdate) {
      return;
    }

    this.sliderView.setValue(
      this.model.get('user_value'), { noEvent: true });

    return false;
  },

  /**
   * Is called when then infobox is clicked.
   * @override
   */
  handleInputElementInfoBoxShowed: function () {
    this.trigger('show');

    if (this.model.get('has_flash_movie')) {
      flowplayer('a.player', '/flash/flowplayer-3.2.6.swf');
    }
  },

  /**
   * ## Event Handlers
   */

  /**
   * Updates elements of the UI to show the new slider value, but does _not_
   * set the value on the model (which is done later). The value is set on
   * the model as part of the Quinn onComplete callback (see `render`).
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

    this.valueElement.text(newValue);

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
    this.element.toggleClass('info-box-visible');
  }
});

// The number of milliseconds which pass before stepping up and down values
// should begin being repeated.
InputElementView.HOLD_ACCELERATE = 125;
