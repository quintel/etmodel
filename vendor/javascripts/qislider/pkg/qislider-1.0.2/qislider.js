


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

/**
 * The slider class is responsible for drawing the slider and maintaining
 * all states of the slider.
 */
var SliderVO = EventDispatcher.extend({
  /**
   * This will initialize the slider.
   */
  init:function(options) {
    options = options || {};
    this.options = options;
    this.precision = options.precision || null;
    this.max_value = options.max_value || 100;
    this.min_value = options.min_value || 0;
    this.step_value = options.step_value;
    this.value = options.value || 0;
    this.reset_value = this.value;
    this.relative = new SliderVoRelative(this);
  },

  setMaxValue:function(value) {
    this.max_value = value;
  },

  getMaxValue:function(value) {
    return this.max_value;
  },

  setMinValue:function(value) {
    this.min_value = value;
  },

  getStepValue:function() {
    if(!this.step_value) {
      return (this.max_value - this.min_value) / 100;
    }
    return this.step_value;
  },

  setStepValue:function(value) {
    this.step_value = value;
  },

  getMinValue:function(value) {
    return this.min_value;
  },

  getRange:function() {
    return this.max_value - this.min_value;
  },

  /**
   * Sets the value of the slider, if it mets the constraints of
   * the min value and max value. You can however override this value
   * by setting the options.
   */
  setValue:function(value, settings) {
    if(this.options && this.options.disabled) {
      return false;
    }
    var roundedValue = this.getRoundedStepValue(value);
    if(!settings || settings && (settings.check != false && !settings.set_to_extreme)) {
      if(roundedValue < this.min_value || roundedValue > this.max_value)
        return false;
    }



    if(settings && settings.set_to_extreme) {
      if(roundedValue < this.min_value) {
        this.value = this.min_value;
      } else if(roundedValue > this.max_value) {
        this.value = this.max_value;
      } else {
        this.value = roundedValue;
      }

    } else {
      this.value = roundedValue;
    }


    if(!(settings && settings.noEvent)) {
      this.dispatchEvent('update', this);
    }

  },

  /**
   * Rounds the value to the nearest step value.
   */
  getRoundedStepValue:function(value) {
    var diff = Math.abs((value % this.getStepValue()));
    if(diff < (this.getStepValue() / 2)) {
      return value - diff;
    } else {
      return value - diff + this.getStepValue();
    }
  },

  isFixed:function() {
    return this.options && this.options.fixed;
  },


  getValue:function() {
    return this.value;
  },
  getRoundedValue:function() {
    if(this.precision)
      return this.value.toFixed(this.precision);
    return this.value;
  },
  getFormattedValue:function() {
    return this.formatValue(this.getRoundedValue());
  },
  formatValue:function(value) {
    if(this.options && this.options.formatter) {
      return this.options.formatter.call(this, value);
    } else {
      return value;
    }
  },
  getResetValue:function() {
    return this.reset_value;
  },
  reset:function() {
    this.setValue(this.reset_value);
  },
  isDirty:function() {
    return this.value != this.reset_value;
  },
  isDisabled:function() {
    return this.options.disabled;
  }


});
/**
 * Adjusts the slider with steps
 */

var StepValueAdjuster = EventDispatcher.extend({
  init:function(sliderVO) {
    this.sliderVO = sliderVO;
  },

  getStepValue:function() {
    return this.sliderVO.relative.getPosition(this.sliderVO.getStepValue());
  },

  reset:function() {
    this.amtTimes = 0;
    this.standardSleepTime = 100;
  },

  enable:function(direction) {
    this.direction = direction;
    this.enabled = true;
    this.reset();
    this.adjustStepValue();
  },
  disable:function() {
    this.enabled = false;
  },
  adjustStepValue:function() {
    if(!this.enabled)
      return;

    var lPosition = this.sliderVO.relative.getPosition(this.sliderVO.getValue());
    var lRelativeStep = this.sliderVO.relative.getPosition(this.sliderVO.getStepValue());
    this.sliderVO.setValue(this.sliderVO.getValue() + this.direction * this.sliderVO.getStepValue());
    this.dispatchEvent("update");

    if(this.enabled)
      setTimeout(jQuery.proxy(this.adjustStepValue, this), this.standardSleepTime);
    this.standardSleepTime = this.standardSleepTime / 1.08;
  }
});
var SliderBar = EventDispatcher.extend({

  init:function(options) {
    this.element = $('<div></div');
    this.element.addClass('slider-bar');
    this.width = options.sliderWidth;
  },
  getX:function(x) {
    return x - this.element.offset().left;
  },
  getWidth:function() {
    return this.width;
  },
  getPosition:function(globalX) {
    return this.getX(globalX) / this.getWidth();
  }


});

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
/**
 * This button is used in a slider.
 */
var SliderLeftButton = SliderButton.extend({

  init:function(opts) {
    this._super({'className':'slider-left-button', 'name':'left', 'disabled':opts && opts.disabled});
  }


});
/**
 * This button is used in a slider.
 */
var SliderRightButton = SliderButton.extend({

  init:function(opts) {
    this._super({'className':'slider-right-button', 'name':'right','disabled':opts && opts.disabled});
  }


});
/**
 * This button is used in a slider.
 */
var SliderToggleButton = SliderButton.extend({

  init:function(sliderBar, opts) {
    this._super({'className':'slider-toggle-button'});
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
var Browser = {
  doesTouch:function() {
       try {
           document.createEvent("TouchEvent");
           return true;
       } catch(e) {

           return false;
       }
   },

   makeSureArrayHasFunctionIndexOf:function() {
     if (!Array.indexOf) {
       Array.prototype.indexOf = function (obj, start) {
         for (var i = (start || 0); i < this.length; i++) {
           if (this[i] == obj) {
             return i;
           }
         }
         return -1;
       }
     }
   }

}



Browser.makeSureArrayHasFunctionIndexOf();



/**
 * The slider class is responsible for drawing the slider and maintaining
 * all states of the slider.
 */
var Slider = EventDispatcher.extend({

  /**
   * View of the slider.
   */
  init:function(sliderVO, options) {
    this.options = options || {};
    this.element = $('<div></div>');
    this.element.addClass('slider');
    if(!this.options.sliderWidth)
      this.options.sliderWidth = 110;
    this.element.bind('selectstart', function() {
      return false;
    })

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


    if(!this.options.disabled) {
      this.initEventListeners();
    } else {
      this.element.addClass('slider-disabled')
    }


    this.element.append($('<div>').addClass('clear'));

    if(Browser.doesTouch()) {
      this.leftButton.setHover();
      this.rightButton.setHover();
    }
    this.sliderVO.addEventListener('update', jQuery.proxy(this.redraw, this));
    this.redraw();
    $(window).load(jQuery.proxy(this.redraw, this));
  },

  /**
   * Initialize all event listeners.
   */
  initEventListeners:function() {
    this.element.bind('mouseover', jQuery.proxy(this.handleMouseOver, this));
    this.element.bind('mouseout', jQuery.proxy(this.handleMouseOut, this));

    this.leftButton.addEventListener('down', jQuery.proxy(this.handleLeftButtonDown, this));
    this.rightButton.addEventListener('down', jQuery.proxy(this.handleRightButtonDown, this));

    if(!Browser.doesTouch()) {
     this.sliderBar.element.bind('mousedown', jQuery.proxy(this.handleToggleButtonDown, this));

    } else {
     this.toggleButton.element.bind('touchstart', jQuery.proxy(this.handleTouchStart, this));
     this.sliderBar.element.bind('touchstart', jQuery.proxy(this.handleTouchStart, this));
     this.sliderBar.element.bind('touchend', jQuery.proxy(this.handleTouchEnd, this));
     $(document).bind('touchend', jQuery.proxy(this.handleTouchEnd, this));
    }
    this.toggleButton.addEventListener('down', jQuery.proxy(this.handleToggleButtonDown, this));

    this.sliderVO.addEventListener('update', jQuery.proxy(function() {
      this.dispatchEvent('move', this);
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
    this.dispatchEvent('toggleButtonDown', this);
    $(document).bind('mouseup', jQuery.proxy(this.handleToggleButtonUp, this));
  },

  /**
   * When the toggle button is up, this is invoked.
   */
  handleToggleButtonUp:function() {
    $(document).unbind('mousemove', jQuery.proxy(this.handleMouseMove, this));
    this.sliderBar.element.unbind('mouseup', jQuery.proxy(this.handleToggleButtonUp, this));
    this.dispatchEvent('change');
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
    this.dispatchEvent('change');
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
    this.dispatchEvent('change');
  },
  handleRightButtonUp:function() {
    this.stepValueAdjuster.disable();
    $(document).unbind('mouseup', jQuery.proxy(this.handleRightButtonUp, this));
    this.dispatchEvent('change');
  },


  setPosition:function(position) {

    position = Math.min(position, 1);
    position = Math.max(position, 0);
    this.sliderVO.relative.setPosition(position);
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

var SimpleSliderView = EventDispatcher.extend({

  init:function(options) {
    this.options = options;
    this.sliderVO = new SliderVO(this.options);
    this.slider = new Slider(this.sliderVO, this.options);
    this.element = $('<div></div>');
    this.element.append(this.slider.element);

  }

});
var SliderInfoBox = EventDispatcher.extend({
  init:function(sliderVO, opts) {
    var infoBoxElement;
    if(opts.element)
      infoBoxElement = $('.info-box', opts.element);


    if(infoBoxElement) {
      this.element = infoBoxElement;
    } else {
      this.element = $('<div> \
        <div class="text">  \
          Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. \
        </div> \
          \
        <div class="clear"></div> \
      </div>');
    }

    this.element.addClass('slider-info-box');
    this.element.append( $('<div class="data"> \
      <div class="label">Old value:</div> \
      <div class="old_value value"></div> \
      <div class="label">New value:</div> \
      <div class="new_value value"></div> \
      <div class="label">Change:</div> \
      <div class="change_value value"></div> \
    </div> \
    <div class="clear"></div>'));


    if(opts.infoBox && opts.infoBox.disableDataBox) {
      $('.data', this.element).hide();
      $('.text', this.element).addClass('text-without-data');
    }


    this.sliderVO = sliderVO;

    this.sliderVO.addEventListener("update", jQuery.proxy(this.handleSliderUpdate, this));
    this.isVisible = false;
    this.handleSliderUpdate();
  },

  visible:function() {
    return this.isVisible;
  },

  toggle:function() {
    if(!this.visible()) {
      this.show("slow");
    } else {
      this.hide("slow");
    }
  },

  show:function() {
    this.element.show();
    this.isVisible = true;
    this.dispatchEvent("visibility")
    this.dispatchEvent("show", this);
  },
  hide:function() {
    this.element.hide();
    this.isVisible = false;
    this.dispatchEvent("visibility")
    this.dispatchEvent("hide", this);
  },

  handleSliderUpdate:function() {
    $('.old_value', this.element).html(this.sliderVO.formatValue(this.sliderVO.getResetValue()));
    $('.new_value', this.element).html(this.sliderVO.getFormattedValue());
    var percentage = (((this.sliderVO.getValue() / this.sliderVO.getResetValue()) * 100) - 100).toFixed(1) + "%";

    $('.change_value', this.element).html(percentage);
  }

})
var SliderInput = EventDispatcher.extend({
  init:function(sliderVO) {
    this.sliderVO = sliderVO;
    this.element = $('<div></div>');
    this.element.addClass('slider-input');
    this.element.attr('title', 'Click to edit this value.');

    this.value_element = $('<div>').addClass('value');
    this.edit_element = $('<div>').addClass('edit');
    this.element.append(this.value_element);
    this.element.append(this.edit_element);
    this.value_element.bind('click', jQuery.proxy(this.handleStartEdit, this));
    this.edit_element.bind('click', jQuery.proxy(this.handleStartEdit, this));
    this.edit_element.hide();




    this.edit_form_element = $('<form>').addClass('edit-value');
    this.input_element = $('<input type="text">');
    this.cancel_element = $('<input type="button" value="Cancel">');
    this.cancel_element.bind('click', jQuery.proxy(this.handleCancelEdit, this));
    this.ok_button = $('<input type="submit" value="OK">');
    this.ok_button.bind('click', jQuery.proxy(this.handleFinishedEdit, this))
    this.edit_form_element.bind('submit', jQuery.proxy(this.handleFinishedEdit, this))


    this.edit_form_element.append(this.input_element);
    this.edit_form_element.append(this.ok_button);
    this.edit_element.hide();

    this.edit_form_element.hide();
    this.element.append(this.edit_form_element);


    this.sliderVO.addEventListener('update', jQuery.proxy(this.handleUpdate, this));
    this.draw();
  },

  handleUpdate:function(e) {
    this.draw();
  },
  draw:function() {
    this.value_element.html(this.sliderVO.getFormattedValue());
    this.input_element.attr('value', this.sliderVO.getRoundedValue());
  },
  mouseOver:function() {
  },
  mouseOut:function() {
  },

  /**
   * If edit is clicked the input element, will be a text edit.
   */
  handleStartEdit:function() {
    if(this.sliderVO.isDisabled()) {
      return false;
    }
    this.value_element.hide();
    this.edit_form_element.show();
    this.firstClick = true;
    $(document).bind('click', jQuery.proxy(this.handleCancelEdit, this));
  },

  handleCancelEdit:function(e) {
    var lParents = $(e.target).parents();
    for(var i = 0; i < lParents.length; i++) {
      if(lParents[i] == this.element[0])
        return;
    }

    this.draw()
    this.value_element.show();
    this.edit_form_element.hide();
    $(document).unbind('click', jQuery.proxy(this.handleCancelEdit, this));
  },
  handleFinishedEdit:function() {
    this.sliderVO.setValue(this.input_element.attr('value'));
    this.dispatchEvent('update');
    this.value_element.show();
    this.edit_form_element.hide();
    this.edit_element.hide();
    $(document).unbind('click', jQuery.proxy(this.handleCancelEdit, this));
    return false; // needed for form
  }

})
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
var SliderDownButton = SliderButton.extend({

  init:function(opts) {
    this._super({'className':'slider-down-button', 'name':'down'});
  }


});


var AdvancedSliderView = EventDispatcher.extend({

  init:function(options) {
    this.options = options;


    this.sliderVO = new SliderVO(this.options);
    this.slider = new Slider(this.sliderVO, this.options);
    this.resetButton = new SliderResetButton();
    this.resetButton.hide();
    this.downButton = new SliderDownButton();
    this.sliderInput = new SliderInput(this.getSliderVO());
    this.infoBox = new SliderInfoBox(this.slider.getSliderVO(), options);

    this.initElements();
    this.initEventListeners();

    if(this.options.element)
      this.options.element.append(this.element);
  },

  /**
   * Here the slider is drawn.
   */
  initElements:function() {
    this.element = $('<div></div>');
    this.element.addClass('slider-advanced');
    this.topRowElement = $('<div></div>').addClass('toprow');
    this.element.append(this.topRowElement);


    if(this.options.element)
      this.nameElement = $('.name', this.options.element);

    if(!this.nameElement || this.nameElement.length == 0) {
      this.name = this.options.name || "untitled";
      this.nameElement = $('<div class="name"></div>').html(this.name);
    }

    this.nameElement.bind('selectstart', function() {return false;});
    this.sliderElementsElement = $('<div></div>').addClass('slider-elements');
    this.topRowElement.append(this.sliderElementsElement);
    this.topRowElement.append(this.nameElement);



    this.sliderElementsElement.append(this.resetButton.element);
    this.sliderElementsElement.append(this.slider.element);
    this.element.append(this.downButton.element);
    this.sliderElementsElement.append(this.sliderInput.element);
    this.sliderElementsElement.append(this.downButton.element);
    this.resetButton.addEventListener('up', jQuery.proxy(this.handleReset, this));
    this.topRowElement.append($('<div>').addClass('clear'));
    this.element.append($('<div>').addClass('clear'));
    this.element.append(this.infoBox.element);

  },

  /**
   * Return the infobox.
   */
  getInfoBox:function() {
    return this.infoBox;
  },

  /**
   * All event listeners are initialized.
   */
  initEventListeners:function() {
    this.sliderInput.addEventListener('update', jQuery.proxy(function() {
      this.dispatchEvent('change');
    }, this));

    this.slider.addEventListener('change', jQuery.proxy(function() {
      this.dispatchEvent('change');
    }, this));

    this.nameElement.bind('click', jQuery.proxy(function() {this.infoBox.toggle();}, this));
    this.infoBox.addEventListener('visibility', jQuery.proxy(this.handleVisibilityChange, this));
    this.downButton.addEventListener('click', jQuery.proxy(this.handleDownButtonClicked, this));
    this.element.bind('mouseover', jQuery.proxy(this.handleMouseOver, this));
    this.element.bind('mouseout', jQuery.proxy(this.handleMouseOut, this));

    if(!this.options.disabled) {
      this.resetButton.addEventListener('up', jQuery.proxy(this.handleReset, this));
    }

  },

  getSliderVO:function() {
    return this.sliderVO;
  },

  handleReset:function() {

    this.sliderVO.reset();
    this.dispatchEvent('change');
  },
  handleMouseOver:function() {

    if(!this.options.disabled) {
      this.slider.handleMouseOver();
      this.downButton.setHover();

      if(this.resetButton && !this.options.disabled)
        this.resetButton.show();
    }
  },

  handleMouseOut:function() {
    if(!this.options.disabled) {
      this.slider.handleMouseOut();
      this.downButton.setHover();
      if(this.resetButton)
        this.resetButton.hide();
    }
  },

  handleDownButtonClicked:function() {
    this.infoBox.toggle();
  },
  handleVisibilityChange:function() {
    if(this.infoBox.visible()) {
      this.element.unbind('mouseout', jQuery.proxy(this.handleMouseOut, this));
      this.element.addClass("slider-opened");
    } else {
      this.element.bind('mouseout', jQuery.proxy(this.handleMouseOut, this));
      this.element.removeClass("slider-opened");
    }
  },

  setValue:function(pValue, opts) {
    this.slider.setValue(pValue, opts);
    this.sliderInput.draw();
  }

});
var SliderGroup = EventDispatcher.extend({
  init:function(opts) {
    this.opts = opts || {};
    this.sliders = [];
    this.sliderChangeStack = [];
    this.sliderUpdateFunctions = [];
  },

  getTotalValue:function() {
    if(this.opts.total_value)
      return this.opts.total_value;
    return this.getTotalMaxSliderValue() / this.sliders.length;
  },

  addSlider:function(pSlider) {
    this.sliders.push(pSlider);
    $(window).load(jQuery.proxy( function() { this.handleSliderChange(pSlider) }, this));

    this.disableEventListeners();
    this.enableEventListeners();
  },

  disableEventListeners:function() {
    for(var i = 0; i < this.sliders.length; i++) {
      this.sliders[i].removeEventListener('update', this.sliderUpdateFunctions[i]);
    }
    this.sliderUpdateFunctions = [];

  },

  enableEventListeners:function() {
    for(var i = 0; i < this.sliders.length; i++) {
      this.sliderUpdateFunctions.push(jQuery.proxy(this.handleUpdate, this));
      this.sliders[i].addEventListener('update', this.sliderUpdateFunctions[i]);
    }
  },


  handleUpdate:function(slider) {
      this.handleSliderChange(slider);
      this.handleSliderTouched(slider);
      this.dispatchEvent("slider_updated");
  },
  /**
   * This method calculates how much the others must in or decrease. It chooses a slider to adjust.
   * This slider is selected by sorting the sliders on last changed.
   */
  handleSliderChange:function(pSlider) {
    this.disableEventListeners();

    var k = 0;
    while(k < 20 && this.getTotalToAdjust() != 0) {
      var lSlider = this.getAdjustableSlider(pSlider, k % (this.sliders.length - 1));
      var lStep  = (this.getTotalToAdjust());
      lSlider.setValue(lSlider.getValue() + lStep, {set_to_extreme:true});
      k++;
    }
    if(this.getTotalToAdjust() < 0) {
      pSlider.setValue(pSlider.getValue() + this.getTotalToAdjust());
    }



    this.enableEventListeners();

  },
  handleSliderTouched:function(slider) {
    var lIndex = this.sliderChangeStack.indexOf(slider);
    if(lIndex != -1)
      this.sliderChangeStack.splice(lIndex, 1);
    console.info(slider)
    this.sliderChangeStack.push(slider);
  },

  getAdjustableSlider:function(pSlider, k) {
    var lSorted = this.sliders.sort(jQuery.proxy(function(a, b) {
      return this.sliderChangeStack.indexOf(a) - this.sliderChangeStack.indexOf(b);
    }, this));


    if(this.sliders.length == 1) {
      return lSorted[0];
    }

    var lSortedAndRemoved = [];
    for(var i = 0; i < lSorted.length; i++) {

      if(lSorted[i].isFixed()) {
        if(i < k) k--;
      } else {
        if(lSorted[i] != pSlider)
          lSortedAndRemoved.push(lSorted[i]);

      }
    }
    return lSortedAndRemoved[k];


  },

  getTotalToAdjust:function() {
    return this.getTotalValue() - this.getTotalSliderValue();
  },

  getTotalSliderValue:function(options) {
    options = options || {};


    var lTotalRestSliderValue = 0;
    for(var i = 0; i < this.sliders.length; i++) {
      if(!(options && options.except && options.except.indexOf(this.sliders[i]) != -1))
        lTotalRestSliderValue += this.sliders[i].getValue();
    }

    return lTotalRestSliderValue;
  },

  getTotalMaxSliderValue:function(options) {
    options = options == null ? {} : options;


    var lTotalRestSliderValue = 0;
    for(var i = 0; i < this.sliders.length; i++) {
      if(!(options && options.except && options.except.indexOf(this.sliders[i]) != -1))
        lTotalRestSliderValue += this.sliders[i].getMaxValue();
    }

    return lTotalRestSliderValue;
  }



});
var SliderFormatter = {

  format: function(n, symbol) {

    symbol = symbol == null ? "%" : symbol;
    out = n + " " +  symbol;
    return out;

  },



  /**
   * Return a function that displays the page  with a specific precision
   */
  roundingFactory: function(precision, symbol) {

    return $.proxy(function(n) {
      return this.format(n, precision, symbol);
    }, this);
  },

  /**
   * Return a function that displays the page  with a specific precision
   */
  numberWithSymbolFactory: function(symbol) {

    return $.proxy(function(n) {
      return this.format(n, symbol);
    }, this);
  }

}
