require 'spec_helper'

describe InputElement do
  
  describe "set correct input_elements as disabled" do
    it "should be true when input_element is has_locked_input_element_type?" do
      InputElement.stub!(:find).and_return([])
      input_element = InputElement.new
      input_element.has_locked_input_element_type?("fixed").should be_true
      input_element.has_locked_input_element_type?("share").should be_false
    end
  end

  describe "#caching of values" do
    pending
  end
end



