/**
 * This button is used in a slider.
 */
var SliderResetButton = SliderButton.extend({
  
  initialize:function(opts) {
    
    // backbone super method calling is uggly, sorry!
    SliderResetButton.__super__.initialize.call(this, {'className':'slider-reset-button', 'name':'reset'});
    
    // this._super({'className':'slider-reset-button', 'name':'reset'});
  },
  hide:function() {
    this.element.css('opacity', 0);
  },
  show:function() {
    this.element.css('opacity', 1);
  }
  
  
});