
/**
 * This button is used in a slider.
 * 
 */
var SliderButton = EventDispatcher.extend({
  init:function(opts) {
    this.element = $('<div></div>');
    this.element.addClass('slider-button')
    this.name = opts.name;
    
    if(!(opts && opts.disabled)) {
      if(!Browser.doesTouch()) {
        this.element.bind('mousedown', jQuery.proxy(this.handleMouseDown, this));
        this.element.bind('mouseup', jQuery.proxy(this.handleMouseUp, this));
        $(document).bind('mouseup', jQuery.proxy(function() { 
          this.element.removeClass('slider-button-over');
          this.element.removeClass('slider-button-active');
          this.element.removeClass('slider-' +this.name+ '-button-active');
        }, this));
      
        this.element.bind('selectstart', function() {return false;});
        this.element.bind('mouseover', jQuery.proxy(this.handleMouseOver, this));
        this.element.bind('mouseout', jQuery.proxy(this.handleMouseOut, this))
      } else {
        this.element.bind('touchstart', jQuery.proxy(this.handleMouseDown, this));
        this.element.bind('touchend', jQuery.proxy(this.handleMouseUp, this));
        //$(document).bind('touchend', jQuery.proxy(this.handleMouseUp, this));
      }
    }
    if(opts.className) {
      this.element.addClass(opts.className)
    } 
  },  
  handleMouseDown:function() {
    this.dispatchEvent('down');
    this.setActive();
  },
  setActive:function() {
    this.element.addClass('slider-button-active')
    this.element.addClass('slider-'+this.name+'-button-active')
    this.disableMouseOver = true;
  },
  setNormal:function() {
    this.element.removeClass('slider-button-active')
    this.element.removeClass('slider-'+this.name+'-button-active')
    this.element.removeClass('slider-button-over')
    this.element.removeClass('slider-'+this.name+'-button-over')
    
    this.disableMouseOver = true;
  },

  setHover:function() {
    this.element.addClass('slider-button-over')
    this.element.addClass('slider-'+this.name+'-button-over')
    this.disableMouseOver = true;
  },
  
  handleMouseUp:function() {
    this.dispatchEvent('up');
    this.dispatchEvent('click');
    this.disableMouseOver = false;

    this.element.removeClass('slider-button-active')
    this.element.removeClass('slider-' +this.name+ '-button-active')
    //this.element.removeClass('slider-button-over');
  },
  handleMouseOver:function() {    
    this.element.addClass('slider-button-over');
    if(this.name) 
      this.element.addClass('slider-'+this.name + '-button-over');
  },
  
  handleMouseOut:function() {
    if(!this.disableMouseOver)
      this.element.removeClass('slider-button-over');
      if(this.name) 
        this.element.removeClass('slider-'+this.name+'-button-over');
  }
});