/**
 * This button is used in a slider.
 */
var SliderRightButton = SliderButton.extend({
  
  initialize:function(opts) {
    SliderRightButton.__super__.initialize.call(this, {'className':'slider-right-button', 'name':'right','disabled':opts && opts.disabled});
    // this._super({'className':'slider-right-button', 'name':'right','disabled':opts && opts.disabled});
  }
  
  
});