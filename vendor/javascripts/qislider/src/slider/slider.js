//= require <slider/slider_vo>
//= require <slider/slider_step_value_chooser>
//= require <slider/ui/slider_bar>
//= require <slider/ui/slider_left_button>
//= require <slider/ui/slider_right_button>
//= require <slider/ui/slider_toggle_button>
//= require <slider/browser>



/**
 * The slider class is responsible for drawing the slider and maintaining
 * all states of the slider.
 */
var Slider = Backbone.Model.extend({
  
  /**
   * View of the slider.
   */
  initialize:function(sliderVO, options) {
  
    this.options = options || {};
    this.element = $('<div></div>');
    this.element.addClass('slider');
    if(!this.options.sliderWidth)
      this.options.sliderWidth = 110;
    this.element.bind('selectstart', function() {
      return false;
    })
    
    // this holds and controls the data
    this.sliderVO = sliderVO;
    this.sliderBar = new SliderBar(this.options);
    this.toggleButton = new SliderToggleButton(this.sliderBar, options);
    this.leftButton = new SliderLeftButton(this.options);
    this.rightButton = new SliderRightButton(this.options);
    this.stepValueAdjuster = new StepValueAdjuster(this.sliderVO);
    
    this.element.append(this.sliderBar.element);
    this.element.append(this.leftButton.element);
    this.sliderBar.element.append(this.toggleButton.element);
    this.element.prepend(this.rightButton.element);
    
    this.initEventListeners();
    
    if(!this.options.disabled) {
      this.initEventListeners();
    }
    else{
      this.element.addClass('slider-disabled')
    }
    this.element.append($('<div>').addClass('clear'));
    
    if(Browser.doesTouch()) {
      this.leftButton.setHover();
      this.rightButton.setHover();
    }
  
    this.sliderVO.bind('update', jQuery.proxy(this.redraw, this));
    this.redraw();
    $(window).load(jQuery.proxy(this.redraw, this));
  },
  
  /**
   * Initialize all event listeners.
   */
  initEventListeners:function() {
    

      // if we move over the slider, show edit icon
      this.element.bind('mouseover', jQuery.proxy(this.handleMouseOver, this));
      this.element.bind('mouseout', jQuery.proxy(this.handleMouseOut, this));    

      this.leftButton.bind('down', jQuery.proxy(this.handleLeftButtonDown, this));
      this.rightButton.bind('down', jQuery.proxy(this.handleRightButtonDown, this));

      if(!Browser.doesTouch()) {
       this.sliderBar.element.bind('mouseup', jQuery.proxy(this.handleToggleButtonDown, this));
     
       //
      } else {
       this.toggleButton.element.bind('touchstart', jQuery.proxy(this.handleTouchStart, this));
       this.sliderBar.element.bind('touchstart', jQuery.proxy(this.handleTouchStart, this));
       this.sliderBar.element.bind('touchend', jQuery.proxy(this.handleTouchEnd, this));
       $(document).bind('touchend', jQuery.proxy(this.handleTouchEnd, this));
      }
      this.toggleButton.bind('down', jQuery.proxy(this.handleToggleButtonDown, this));

      this.sliderVO.bind('update', jQuery.proxy(function() {
        this.trigger('move', this);
      }, this));
  },

  /**
   * Get the sliderVO, the object that holds important info about a slider.
   */
  getSliderVO:function() {
    return this.sliderVO;
  },

  /**
   * Handle the mouse over of this slider. Shows the zoombuttons.
   */
  handleMouseOver:function(e) {
    if(!Browser.doesTouch()) {
      this.leftButton.setHover();
      this.rightButton.setHover();
    }
  },
  
  /**
   * Handle the mouse out. Hides the zoombuttons.
   */
  handleMouseOut:function(e) {
    if(!Browser.doesTouch()) {
      this.leftButton.setNormal();
      this.rightButton.setNormal();
    }
  },
  
  /**
   * When the toggle button is down, this is invoked.
   */  
  handleToggleButtonDown:function(e) {
    if(e)
      this.setPosition(this.sliderBar.getPosition(e.pageX));
    this.toggleButton.setActive();
    $(document).bind('mousemove', jQuery.proxy(this.handleMouseMove, this));
    this.sliderBar.element.bind('mouseup', jQuery.proxy(this.handleToggleButtonUp, this));
    this.trigger('toggleButtonDown', this);
    $(document).bind('mouseup', jQuery.proxy(this.handleToggleButtonUp, this));
  },

  /**
   * When the toggle button is up, this is invoked.
   */    
  handleToggleButtonUp:function() {
    $(document).unbind('mousemove', jQuery.proxy(this.handleMouseMove, this));
    this.sliderBar.element.unbind('mouseup', jQuery.proxy(this.handleToggleButtonUp, this));
    this.trigger('change');
    $(document).unbind('mouseup', jQuery.proxy(this.handleToggleButtonUp, this));
  },
  
  /**
   * When the mouse is moved, this is invoked.
   */  
  handleMouseMove:function(e) {
    this.setPosition(this.sliderBar.getPosition(e.pageX));
  },
  
  handleTouchStart:function(e) {
    if(e)
      this.setPosition(this.sliderBar.getPosition(e.originalEvent.targetTouches[0].pageX));
    $(document).bind('touchmove', jQuery.proxy(this.handleTouchMove, this));
    $(document).bind('touchend', jQuery.proxy(this.handleTouchEnd, this));
  },
  handleTouchEnd:function(e) {
    $(document).unbind('touchmove', jQuery.proxy(this.handleTouchMove, this));
    $(document).unbind('touchend', jQuery.proxy(this.handleTouchEnd, this));
    this.trigger('change');
  },
  handleTouchMove:function(e) {
    this.setPosition(this.sliderBar.getPosition(e.originalEvent.targetTouches[0].pageX));
  },
  handleLeftButtonDown:function() {
    this.stepValueAdjuster.enable(-1);
    $(document).bind('mouseup', jQuery.proxy(this.handleLeftButtonUp, this));
  },
  handleRightButtonDown:function() {
    this.stepValueAdjuster.enable(1);
    $(document).bind('mouseup', jQuery.proxy(this.handleRightButtonUp, this));
  },
  handleLeftButtonUp:function() {
    $(document).unbind('mouseup', jQuery.proxy(this.handleLeftButtonUp, this));
    this.stepValueAdjuster.disable();
    this.trigger('change');
  },
  handleRightButtonUp:function() {
    this.stepValueAdjuster.disable();
    $(document).unbind('mouseup', jQuery.proxy(this.handleRightButtonUp, this));
    this.trigger('change');
  },
  

  setPosition:function(position) {
   
    position = Math.min(position, 1);
    position = Math.max(position, 0);
    
    this.sliderVO.relative.setPosition(position);
//    this.trigger('update');
    this.redraw();
  },
  getValue:function() {
    return this.sliderVO.getValue();
  },
  
  setValue:function(pValue, opts) {

    this.sliderVO.setValue(pValue, opts);
    this.redraw();
  },
  
 
  
  redraw:function() {

    this.toggleButton.setPosition(this.sliderVO.relative.getPosition(this.sliderVO.getValue()));
    
    
  }
  
});