var SliderGroup = EventDispatcher.extend({
  init:function(opts) {
    this.opts = opts || {};
    this.sliders = [];
    this.sliderChangeStack = [];
    this.sliderUpdateFunctions = [];
  },
  
  getTotalValue:function() {
    if(this.opts.total_value)
      return this.opts.total_value;
    return this.getTotalMaxSliderValue() / this.sliders.length;
  },
  
  addSlider:function(pSlider) {
    this.sliders.push(pSlider);
    //pSlider.addEventListener('update', jQuery.proxy(this.handleSliderTouched, this));
    $(window).load(jQuery.proxy( function() { this.handleSliderChange(pSlider) }, this));
    
    this.disableEventListeners();
    this.enableEventListeners();
  },
  
  disableEventListeners:function() {
    for(var i = 0; i < this.sliders.length; i++) {
      this.sliders[i].removeEventListener('update', this.sliderUpdateFunctions[i]);
    }
    this.sliderUpdateFunctions = [];
      
  },
  
  enableEventListeners:function() {
    for(var i = 0; i < this.sliders.length; i++) {
      this.sliderUpdateFunctions.push(jQuery.proxy(this.handleUpdate, this));
      this.sliders[i].addEventListener('update', this.sliderUpdateFunctions[i]);
    }  
  },
  
  
  handleUpdate:function(slider) {
      this.handleSliderChange(slider);
      this.handleSliderTouched(slider);
      this.dispatchEvent("slider_updated");
  },
  /**
   * This method calculates how much the others must in or decrease. It chooses a slider to adjust.
   * This slider is selected by sorting the sliders on last changed.
   */
  handleSliderChange:function(pSlider) {
    this.disableEventListeners();

    var k = 0;
    while(k < 20 && this.getTotalToAdjust() != 0) {
      var lSlider = this.getAdjustableSlider(pSlider, k % (this.sliders.length - 1));
      var lStep  = (this.getTotalToAdjust());
      lSlider.setValue(lSlider.getValue() + lStep, {set_to_extreme:true});
      k++;
    }
    // set back
    if(this.getTotalToAdjust() < 0) {
      pSlider.setValue(pSlider.getValue() + this.getTotalToAdjust());
    }
      
    

    this.enableEventListeners();
   
  },
  handleSliderTouched:function(slider) {
    var lIndex = this.sliderChangeStack.indexOf(slider);
    if(lIndex != -1)
      this.sliderChangeStack.splice(lIndex, 1);
    this.sliderChangeStack.push(slider);
  },
  
  getAdjustableSlider:function(pSlider, k) {
    var lSorted = this.sliders.sort(jQuery.proxy(function(a, b) {
      return this.sliderChangeStack.indexOf(a) - this.sliderChangeStack.indexOf(b);
    }, this));
    

    if(this.sliders.length == 1) {
      return lSorted[0];
    }
    
    var lSortedAndRemoved = [];
    for(var i = 0; i < lSorted.length; i++) {
        
      if(lSorted[i].isFixed()) {
        if(i < k) k--;
      } else {
        if(lSorted[i] != pSlider)
          lSortedAndRemoved.push(lSorted[i]);
    
      }
    }
    return lSortedAndRemoved[k];
  
    
  },
  
  getTotalToAdjust:function() {
    return this.getTotalValue() - this.getTotalSliderValue();
  },
  
  getTotalSliderValue:function(options) {
    options = options || {};

    
    var lTotalRestSliderValue = 0;
    for(var i = 0; i < this.sliders.length; i++) {
      if(!(options && options.except && options.except.indexOf(this.sliders[i]) != -1))
        lTotalRestSliderValue += this.sliders[i].getValue();
    }
    
    return lTotalRestSliderValue;
  },
  
  getTotalMaxSliderValue:function(options) {
    options = options == null ? {} : options;

    
    var lTotalRestSliderValue = 0;
    for(var i = 0; i < this.sliders.length; i++) {
      if(!(options && options.except && options.except.indexOf(this.sliders[i]) != -1))
        lTotalRestSliderValue += this.sliders[i].getMaxValue();
    }
    
    return lTotalRestSliderValue;
  }
  
  
  
});