/**
 * This button is used in a slider.
 */
var SliderResetButton = SliderButton.extend({
  
  init:function(opts) {
    this._super({'className':'slider-reset-button', 'name':'reset'});
  },
  hide:function() {
    this.element.css('opacity', 0);
  },
  show:function() {
    this.element.css('opacity', 1);
  }
  
  
});