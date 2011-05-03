/**
 * The slider class is responsible for drawing the slider and maintaining
 * all states of the slider.
 */
var SliderVoRelative = EventDispatcher.extend({
  
  init:function(sliderVO) {
    this.sliderVO = sliderVO;
  },
  
  setPosition:function(value) {
    this.sliderVO.setValue(value * this.sliderVO.getRange() + this.sliderVO.getMinValue());
  },
  
  getPosition:function(value) {
    return (value - this.sliderVO.getMinValue()) / this.sliderVO.getRange();
  }
  
  
});