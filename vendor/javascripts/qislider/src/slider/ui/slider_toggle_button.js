/**
 * This button is used in a slider.
 */
var SliderToggleButton = SliderButton.extend({
  
  initialize:function(sliderBar, opts) {
    SliderToggleButton.__super__.initialize.call(this, {'className':'slider-toggle-button'});
 
    
    
    // this._super({'className':'slider-toggle-button'});
    this.sliderBar = sliderBar;
    this.width = 20;
  },
  
  setPosition:function(pPos) {
    var lOffsetSliderBarX = this.sliderBar.getWidth() * pPos;

    var lLeft = 10 || this.sliderBar.element.position().left;
    var lOffsetX = lOffsetSliderBarX + lLeft - (this.width / 2);
   
    this.element.css('left', lOffsetSliderBarX - (this.width / 2))
  }
  
  
});