require 'spec_helper'

describe InputElement do

  describe "#step_value" do

    
    let(:original_step_value) { 0.07 } 

    it "should be 1/100th of value in database when controller name is supply and is locked for municipality" do
      Current.stub_chain(:scenario, :area, :is_municipality?).and_return(true)
      Current.stub_chain(:scenario, :municipality?).and_return(true)
      input_element = InputElement.new(:locked_for_municipalities => true, :step_value => original_step_value)
      input_element.stub_chain(:slide, :controller_name).and_return("supply")
      input_element.step_value.to_f.should be_within( 0.01).of(original_step_value/100)
    end
    
    it "should be equal to value in database when controller name is not supply and is locked for municipality" do
      Current.stub_chain(:scenario, :area, :is_municipality?).and_return(true)
      Current.stub_chain(:scenario, :municipality?).and_return(true)
      input_element = InputElement.new(:locked_for_municipalities => true, :step_value => original_step_value)
      input_element.stub_chain(:slide, :controller_name).and_return("demand")
      input_element.step_value.to_f.should be_within( 0.01).of(original_step_value)
    end

    it "should be equal to value in database when controller name is supply and is not locked for municipality" do
      Current.stub_chain(:scenario, :area, :is_municipality?).and_return(true)
      Current.stub_chain(:scenario, :municipality?).and_return(true)
      input_element = InputElement.new(:locked_for_municipalities => false, :step_value => original_step_value)
      input_element.stub_chain(:slide, :controller_name).and_return("demand")
      input_element.step_value.to_f.should be_within( 0.01).of(original_step_value)
    end

    it "should be equal to value in database when controller name is supply and is locked for municipality" do
      Current.stub_chain(:scenario, :area, :is_municipality?).and_return(false)
      Current.stub_chain(:scenario, :municipality?).and_return(false)
      input_element = InputElement.new(:locked_for_municipalities => true, :step_value => original_step_value)
      input_element.stub_chain(:slide, :controller_name).and_return("supply")
      input_element.step_value.to_f.should be_within( 0.01).of(original_step_value)
    end
        
  end
  
  describe "#calculated_step_value" do
    
    it "should be 1/100th of the difference between max and min" do
      max_value = 137
      min_value = -237
      ie = InputElement.new(:min_value => min_value, :max_value => max_value)
      ie.calculated_step_value.should be_within(0.05).of((max_value - min_value) /100.0)
    end
    
  end


  describe "#input_elements_to_update" do
    it "should split a value" do
       InputElement.stub!(:find).and_return(["",""])
       input_element = InputElement.new
       input_element.stub!(:update_value).and_return("333_334")
       input_element.input_elements_to_update.length.should == 2
    end
    
    it "should find the input elements to update" do
       InputElement.stub!(:find).and_return([""])
       input_element = InputElement.new
       input_element.stub!(:update_value).and_return("333")
       input_element.input_elements_to_update.length.should == 1
    end
    
    
    it "should should deal with input elements without a update_value" do
       InputElement.stub!(:find).and_return([])
       input_element = InputElement.new
       input_element.stub!(:update_value).and_return("")
       input_element.input_elements_to_update.length.should == 0
    end
    
  end
  
  describe "set correct input_elements as disabled" do
    it "should be true when input_element is locked_for_transition_price? or has_locked_input_element_type?" do
      Current.stub_chain([:server_config, :whitelist]).and_return([ 16])
      InputElement.stub!(:find).and_return([])
      input_element = InputElement.new
      input_element.blacklisted_if_whitelist_available?(256).should be_true #coal plant
      input_element.blacklisted_if_whitelist_available?(16).should  be_false #gas cost
      input_element.has_locked_input_element_type?("fixed").should be_true
      input_element.has_locked_input_element_type?("share").should be_false
    end

  end

  describe "#caching of values" do
    
    
  end
end



# == Schema Information
#
# Table name: input_elements
#
#  id                        :integer(4)      not null, primary key
#  name                      :string(255)
#  slide_id                  :integer(4)
#  share_group               :string(255)
#  start_value_gql           :string(255)
#  min_value_gql             :string(255)
#  max_value_gql             :string(255)
#  min_value                 :float
#  max_value                 :float
#  start_value               :float
#  keys                      :text
#  attr_name                 :string(255)
#  order_by                  :float
#  step_value                :decimal(4, 2)
#  created_at                :datetime
#  updated_at                :datetime
#  update_type               :string(255)
#  unit                      :string(255)
#  factor                    :float
#  input_element_type        :string(255)
#  label                     :string(255)
#  comments                  :text
#  update_value              :string(255)
#  complexity                :integer(4)      default(1)
#  interface_group           :string(255)
#  update_max                :string(255)
#  locked_for_municipalities :boolean(1)
#  label_query               :string(255)
#  key                       :string(255)
#

