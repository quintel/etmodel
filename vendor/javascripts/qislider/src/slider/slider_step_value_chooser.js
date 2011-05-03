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
    //this.sliderVO.relative.setPosition(lPosition + this.direction * lRelativeStep);
    this.sliderVO.setValue(this.sliderVO.getValue() + this.direction * this.sliderVO.getStepValue());
    this.dispatchEvent("update");
    
    if(this.enabled)
      setTimeout(jQuery.proxy(this.adjustStepValue, this), this.standardSleepTime);
    this.standardSleepTime = this.standardSleepTime / 1.08;
  }
});