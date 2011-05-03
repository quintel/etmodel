require 'spec_helper'


describe MetricHelper do
  include MetricHelper
  
  context "scaling of values" do
    it "should scale a big number to a small number" do
      number = 100000
      scale, value = scaled_value(number)
      scale.should == 1
      value.should == 100
    end
    
    
    it "should scale a small number to a bigger number" do
      number = 0.1
      scale, value = scaled_value(number)
      scale.should == 0
      value.should == 0.1
    end
  
     
    it "should convert a small number with a start value to a bigger number" do
      number = 0.2
      scale, value = scaled_value(number, :start_scale => 3)
      value.should == 200
      scale.should == 2
    end
    
    it "should convert a big number with a start value > 20000 to a smaller number" do
      number = 21000
      scale, value = scaled_value(number, :start_scale => 2)
      value.should == 21
      scale.should == 3
    end

    
    it "should not convert a big number with a start value > 10000 to a smaller number" do
      number = 11000
      scale, value = scaled_value(number, :start_scale => 2)
      value.should == 11000
      scale.should == 2
    end

    it "should not convert a big number with a start value < 10000 to a smaller number" do
      number = 1100
      scale, value = scaled_value(number, :start_scale => 2)
      value.should == 1100
      scale.should == 2
    end
    
    
    it "should convert a big number with a start value to a smaller number" do
      number = 0.1
      scale, value = scaled_value(number, :start_scale => 2)
      value.should == 100
      scale.should == 1
    end
  
    it "should respect the options[:max_scale] " do
      number = 1100000
      scale, value = scaled_value(number, :start_scale => 2, :max_scale => 3)
      value.should == 1100
      scale.should == 3
    end
    
    context "target scales" do
      it "should take an option to have a target scale" do
        number = 1100000
        scale, value = scaled_value(number, :target_scale => 2)
        value.should == 1.1
        scale.should == 2
      end
      
      it "should take an option to have a target scale with an start scale" do
        number = 1000 # actually 1000^3
        scale, value = scaled_value(number, :target_scale => 2, :start_scale => 3)
        value.should == 1000000
        scale.should == 2
      end
      
      it "should take an option to have a target scale with an start scale" do
        number = 1000 # actually 1000^1
        scale, value = scaled_value(number, :target_scale => 2, :start_scale => 1)
        value.should == 1
        scale.should == 2
      end
      
      
      
      it "should convert a big number with a start value to a smaller number" do
        number = 1
        scale, value = scaled_value(number, :start_scale => 3, :target_scale => 4)
        value.should == 0.001
        scale.should == 4
      end
      
    end
    
    
  
  end
  
end