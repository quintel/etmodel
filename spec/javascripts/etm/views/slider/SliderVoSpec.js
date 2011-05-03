describe("SliderVO", function() {

  var slider;

  beforeEach(function() {
    slider = new SliderVO();
  });

  it("should be able to set the max value", function() {
    slider.setMaxValue(10);
    expect(slider.getMaxValue()).toEqual(10);
  });
  
  it("should be able to set the min value", function() {
    slider.setMinValue(10);
    expect(slider.getMinValue()).toEqual(10);
  });
  
  it("should not be able to set the value", function() {
    slider.setValue(11);
    slider.setMinValue(10);
    slider.setValue(5);
    expect(slider.getValue()).toEqual(11);
  });
  
  it("should have a step value of 0.1", function() {
    expect(slider.getStepValue()).toEqual(1);
  })
  
  it("should step the step value to 0.1", function() {
    slider.setStepValue(0.2);
    expect(slider.getStepValue()).toEqual(0.2);
  })
  
  
  
});
  
  