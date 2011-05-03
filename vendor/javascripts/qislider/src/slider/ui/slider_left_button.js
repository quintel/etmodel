//= require <slider/ui/slider_button>
/**
 * This button is used in a slider.
 */
var SliderLeftButton = SliderButton.extend({
  
  initialize:function(opts) {
    SliderLeftButton.__super__.initialize.call(this, {'className':'slider-left-button', 'name':'left', 'disabled':opts && opts.disabled});
    // this._super({'className':'slider-left-button', 'name':'left', 'disabled':opts && opts.disabled});
  }
  
  
});