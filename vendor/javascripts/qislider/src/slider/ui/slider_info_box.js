var SliderInfoBox = EventDispatcher.extend({
  init:function(sliderVO, opts) {
    var infoBoxElement;
    if(opts.element) 
      infoBoxElement = $('.info-box', opts.element);
    
    
    if(infoBoxElement) {
      this.element = infoBoxElement;
    } else {
      this.element = $('<div> \
        <div class="text">  \
          Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. \
        </div> \
          \
        <div class="clear"></div> \
      </div>');
    }
    
    this.element.addClass('slider-info-box');    
    this.element.append( $('<div class="data"> \
      <div class="label">Old value:</div> \
      <div class="old_value value"></div> \
      <div class="label">New value:</div> \
      <div class="new_value value"></div> \
      <div class="label">Change:</div> \
      <div class="change_value value"></div> \
    </div> \
    <div class="clear"></div>'));
    

    if(opts.infoBox && opts.infoBox.disableDataBox) {
      $('.data', this.element).hide();
      $('.text', this.element).addClass('text-without-data');
    }
      
    
    this.sliderVO = sliderVO;
    
    this.sliderVO.addEventListener("update", jQuery.proxy(this.handleSliderUpdate, this));
    this.isVisible = false;
    this.handleSliderUpdate();
  },
  
  visible:function() {
    return this.isVisible;
  },
  
  toggle:function() {
    if(!this.visible()) {
      this.show("slow");
    } else {
      this.hide("slow");
    }
  },
  
  show:function() {
    this.element.show();
    this.isVisible = true;
    this.dispatchEvent("visibility")
    this.dispatchEvent("show", this);
  },
  hide:function() {
    this.element.hide();
    this.isVisible = false;
    this.dispatchEvent("visibility")
    this.dispatchEvent("hide", this);
  },
  
  handleSliderUpdate:function() {
    $('.old_value', this.element).html(this.sliderVO.formatValue(this.sliderVO.getResetValue()));
    $('.new_value', this.element).html(this.sliderVO.getFormattedValue());
    var percentage = (((this.sliderVO.getValue() / this.sliderVO.getResetValue()) * 100) - 100).toFixed(1) + "%";
    
    $('.change_value', this.element).html(percentage);
  }
  
})