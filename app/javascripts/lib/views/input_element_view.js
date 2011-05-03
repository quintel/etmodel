
/**
 * InputElementView
 * Controls the view of a single input element.
 *
 */
var InputElementView = Class.extend({
  init: function(inputElement,element) {
    _.extend(this, Backbone.Events);
    this.initialize(inputElement,element);
  },

  initialize:function(inputElement, element) {
    _.bindAll(this, 'updateHandler');
    this.model = inputElement;
    this.element = element;
    inputElement.bind('change', this.updateHandler);

    var lSliderOptions = {  'reset_value': this.model.get('start_value'), 
                            'value':       this.model.get('user_value'), 
                            'step_value':  this.model.get('step_value'),
                            'min_value':   this.model.get('min_value'),  
                            'max_value':   this.model.get('max_value'), 
                            'name':        this.model.get('translated_name'), 
                            'share_group': this.model.get('share_group'),
                            'disabled':    this.model.get('disabled'),
                            'fixed':       this.model.get("input_element_type") == "fixed" || this.model.get("input_element_type") == "fixed_share", 
                            'formatter':   this.getFormatter(),
                            'precision':   this.getPrecision(),
                            'element':     this.element, 
                            'infoBox':{'disableDataBox':true}};
    
    this.sliderView = new AdvancedSliderView(lSliderOptions);
    

    // make the toggle red if it's semi unadaptable and in a municipality.
    if(App.municipalityController.isMunicipality() && this.model.get("semi_unadaptable"))  
      this.sliderView.slider.toggleButton.element.addClass('municipality-toggle');
  
    this.initEventListeners();
  },

  /**
   * Init event listeners.
   */
  initEventListeners:function() {
    this.sliderView.slider.sliderVO.bind('update', $.proxy(function() { 
      this.model.set({"user_value" : this.sliderView.slider.getValue()});
    }, this));
    this.sliderView.getInfoBox().bind('show', $.proxy(this.handleInputElementInfoBoxShowed, this));
    this.sliderView.bind('change', $.proxy(this.checkMunicipalityNotice, this));
    this.sliderView.slider.bind('change', $.proxy(this.handleSliderUpdate, this));
    if(this.model.get("disabled_with_message"))
      this.sliderView.slider.sliderBar.element.bind('click', $.proxy(this.checkTransitionpriceNotice, this));
  },
  
  getPrecision:function() {
    var lPrecisionStr = this.model.get('step_value').toString() + "";
    lPrecision = lPrecisionStr.replace('.', '').length - 1;
    return lPrecision;
  },
  /**
   * Returns a formatter on basis of the step_value.
   */
  getFormatter:function() {
    var lPrecision = this.getPrecision();
    switch(this.model.get('unit')) {
      case "%":  
        return SliderFormatter.numberWithSymbolFactory("%");
      case "#":  
        return SliderFormatter.numberWithSymbolFactory("#");
      case "MW":  
        return SliderFormatter.numberWithSymbolFactory("MW");
      case "km2":  
        return SliderFormatter.numberWithSymbolFactory("km2");
      case "km":  
        return SliderFormatter.numberWithSymbolFactory("km");
      case "x":  
        return SliderFormatter.numberWithSymbolFactory("x");

      default:
        return null;
    }
  },
  
  /**
   * When the user does something on a slider this handler is invoked.
   */
  handleSliderUpdate:function() {
    this.disableUpdate = true;
    this.model.set({"user_value" : this.sliderView.slider.getValue()});
    this.sliderView.slider.setValue(this.model.get('user_value'), {'noEvent':true});
    this.disableUpdate = false;
  },
  

  /**
   * This checks if the municipality message has been shown. It is has not been shown, show it!
   */
  checkMunicipalityNotice:function() {
    if(this.model.get("semi_unadaptable") && App.municipalityController.showMessage()) 
      App.municipalityController.showMunicipalityMessage();
  },
  /**
   * This checks if the transitionprice message has been shown. It is has not been shown, show it!
   */
  checkTransitionpriceNotice:function() {
    if(App.transitionpriceController.showMessage()) 
      App.transitionpriceController.showTransitionpriceMessage();
  },  
  /**
   * Is called when something in the constraint model changed.
   * @override
   */
  updateHandler:function() {
    if(this.disableUpdate) return;

    this.sliderView.setValue(this.model.get('user_value'), {'noEvent':true});
  },

  /**
   * Is called when then infobox is clicked.
   * @override
   */
  handleInputElementInfoBoxShowed:function() {
    this.trigger('show');
    if(this.model.get("has_flash_movie")) {
      flowplayer('a.player', '/flash/flowplayer-3.2.6.swf');
    }
  }
});




