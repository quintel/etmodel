//= require <slider/slider_vo_relative>

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
    this.reset_value = options.reset_value;
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
      if (value > 0){
        return value - diff;
      }else{
        return value + diff;
      }
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
    if(this.value >= 10000){ // larger then 10k does not fit nicely in the inputbox when not rounded down
      return this.value.toFixed();
    }
    else{
      if(this.options.precision == null){
        return this.value;  
      } else {
        return this.value.toFixed(this.options.precision);
      }     
    }
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