//= require <slider/slider>

var SimpleSliderView = Backbone.View.extend({
  
  initialize:function(options) {
    this.options = options;
    this.sliderVO = new SliderVO(this.options);
    this.slider = new Slider(this.sliderVO, this.options);
    this.element = $('<div></div>');
    this.element.append(this.slider.element);
    
  }
  
});