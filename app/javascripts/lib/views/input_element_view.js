/**
 * InputElementView
 * Controls the view of a single input element.
 *
 */
var InputElementView = Backbone.View.extend({
  initialize: function (options) {
    _.bindAll(this, 'updateHandler');

    this.model   = this.options.model;
    this.element = this.options.element;

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
    var quinnElement = $('<div class="quinn"></div>').
      css({ width: '110px', height: '22px'});

    this.element.append(quinnElement);

    console.log({
      range: [ this.model.get('min_value') || 0,
               this.model.get('max_value') || 100 ],
      value:   this.model.get('user_value'),
      step:    this.model.get('step_value'),
      disable: this.model.get('disabled')
    });

    // new $.Quinn is an alternative to $(...).quinn(), and allows us to
    // easily keep hold of the Quinn instance.
    this.quinn = new $.Quinn(quinnElement, {
      range: [ this.model.get('min_value') || 0,
               this.model.get('max_value') || 100 ],
      value:   this.model.get('user_value'),
      step:    this.model.get('step_value'),
      disable: this.model.get('disabled')
    });

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
  }
});
