//= require <slider/slider>
//= require <slider/ui/slider_info_box>
//= require <slider/ui/slider_input>
//= require <slider/ui/slider_reset_button>
//= require <slider/ui/slider_down_button>


var AdvancedSliderView = EventDispatcher.extend({
  
  init:function(options) {
    this.options = options;
    
    
    this.sliderVO = new SliderVO(this.options);
    this.slider = new Slider(this.sliderVO, this.options);
    this.resetButton = new SliderResetButton();        
    this.resetButton.hide();
    this.downButton = new SliderDownButton();
    this.sliderInput = new SliderInput(this.getSliderVO());
    this.infoBox = new SliderInfoBox(this.slider.getSliderVO(), options);
    
    this.initElements();
    this.initEventListeners();
    
    // if element is given in the options it will be added automatically here
    if(this.options.element)
      this.options.element.append(this.element);
  },
  
  /**
   * Here the slider is drawn.
   */
  initElements:function() {
    this.element = $('<div></div>');
    this.element.addClass('slider-advanced');
    

    if(this.options.element)
      this.nameElement = $('.name', this.options.element);

    // console.info(this.nameElement.length)
    if(!this.nameElement || this.nameElement.length == 0) {
      this.name = this.options.name || "untitled";
      this.nameElement = $('<div class="name"></div>').html(this.name);
      // console.info("hee")
    }
    this.topRowElement = $('<div></div>').addClass('toprow');
    this.element.append(this.topRowElement);
    
    this.nameElement.bind('selectstart', function() {return false;});    
    this.sliderElementsElement = $('<div></div>').addClass('slider-elements');
    this.topRowElement.append(this.sliderElementsElement);
    this.topRowElement.append(this.nameElement);
    
    
    
    this.sliderElementsElement.append(this.resetButton.element);
    this.sliderElementsElement.append(this.slider.element);    
    this.element.append(this.downButton.element);   
    this.sliderElementsElement.append(this.sliderInput.element);
    this.sliderElementsElement.append(this.downButton.element);
    this.resetButton.addEventListener('up', jQuery.proxy(this.handleReset, this));
    this.topRowElement.append($('<div>').addClass('clear'));
    this.element.append($('<div>').addClass('clear'));
    this.element.append(this.infoBox.element);
    
  },
  
  /**
   * Return the infobox.
   */
  getInfoBox:function() {
    return this.infoBox;
  },
  
  /** 
   * All event listeners are initialized.
   */ 
  initEventListeners:function() {
    this.sliderInput.addEventListener('update', jQuery.proxy(function() {
      this.dispatchEvent('change');
    }, this));

    this.slider.addEventListener('change', jQuery.proxy(function() {
      this.dispatchEvent('change');
    }, this));
  
    this.nameElement.bind('click', jQuery.proxy(function() {this.infoBox.toggle();}, this));
    this.infoBox.addEventListener('visibility', jQuery.proxy(this.handleVisibilityChange, this));
    this.downButton.addEventListener('click', jQuery.proxy(this.handleDownButtonClicked, this));
    this.element.bind('mouseover', jQuery.proxy(this.handleMouseOver, this));
    this.element.bind('mouseout', jQuery.proxy(this.handleMouseOut, this));
    
    if(!this.options.disabled) {
      this.resetButton.addEventListener('up', jQuery.proxy(this.handleReset, this));
    }
    
  },
  
  getSliderVO:function() {
    return this.sliderVO;
  },
  
  handleReset:function() {
    
    this.sliderVO.reset();
    this.dispatchEvent('change');
  },
  handleMouseOver:function() {

    if(!this.options.disabled) {
      this.slider.handleMouseOver();
      this.downButton.setHover();

      if(this.resetButton && !this.options.disabled) 
        this.resetButton.show();
    }
  },
  
  handleMouseOut:function() {
    if(!this.options.disabled) {
      this.slider.handleMouseOut();
      this.downButton.setHover();
      if(this.resetButton) 
        this.resetButton.hide();
    }
  },
  
  handleDownButtonClicked:function() {
    this.infoBox.toggle();
  },  
  handleVisibilityChange:function() {
    if(this.infoBox.visible()) {
      this.element.unbind('mouseout', jQuery.proxy(this.handleMouseOut, this));
      this.element.addClass("slider-opened");
    } else {
      this.element.bind('mouseout', jQuery.proxy(this.handleMouseOut, this));
      this.element.removeClass("slider-opened");
    }
  }, 
  
  setValue:function(pValue, opts) {
    this.slider.setValue(pValue, opts);
    this.sliderInput.draw();    
  }

});