//= require <slider/ui/slider_button>
/**
 * This button is used in a slider.
 */
var SliderLeftButton = SliderButton.extend({
  
  init:function(opts) {
    this._super({'className':'slider-left-button', 'name':'left', 'disabled':opts && opts.disabled});
  }
  
  
});