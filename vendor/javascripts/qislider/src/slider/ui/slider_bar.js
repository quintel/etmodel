var SliderBar = EventDispatcher.extend({
  
  init:function(options) {
    this.element = $('<div></div');
    this.element.addClass('slider-bar');
    this.width = options.sliderWidth;
  },
  getX:function(x) {
    return x - this.element.offset().left;
  },
  getWidth:function() {
    return this.width; 
  },
  getPosition:function(globalX) {
    return this.getX(globalX) / this.getWidth();
  }
  
  
});