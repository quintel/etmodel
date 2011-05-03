/**
 * This button is used in a slider.
 */
var SliderRightButton = SliderButton.extend({
  
  init:function(opts) {
    this._super({'className':'slider-right-button', 'name':'right','disabled':opts && opts.disabled});
  }
  
  
});