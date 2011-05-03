require 'spec_helper'

describe HouseSelectionsController do
  render_views

  before(:each) do
    stub_etm_layout_methods!
    Current.stub!(:graph)
    controller.stub!(:percentage_of_heat_existing_houses).and_return(0.1)
    controller.stub!(:percentage_of_existing_houses).and_return(0.14)
    session[:default_output_element] = "1"
  end
  
  describe "tool" do
    it "should clear the label sessions when opening the tool " do
      post "tool"
      session["house_label_existing"].should eql(nil)
      session["house_label_new"].should eql(nil)
    end
  end
  
  describe "selecting a label" do
    it "should initialize the calculated sliders session" do
      post "tool"
      post "set_house_selection_label", :lbl => 'a', :id => 'new'
      session['calculated_hst_sliders'].should_not eql(nil)
    end
    
    %w[aaa aa a b c].each do |lbl|      
      it "should set house label new session be '#{lbl}' when this label is chosen" do
        post "tool"
        post "set_house_selection_label", :lbl => lbl, :id => 'new'        
        session["house_label_new"].should eql(lbl)
      end
    end
    
    %w[a b c d c].each do |lbl|      
      it "should set house label existing session be '#{lbl}' when this label is chosen" do
        post "tool"
        post "set_house_selection_label", :lbl => lbl, :id => 'existing'        
        session["house_label_existing"].should eql(lbl)
      end
    end
    
    it "should only calculate when both labels are chosen" do
      controller.stub!(:render)
      
      controller.stub!(:update_installation_sliders)
      get "tool"
      controller.send(:labels_ready_to_calculate?).should be_false
      get "set_house_selection_label", :lbl => "a", :id => 'existing'        
      controller.send(:labels_ready_to_calculate?).should be_false
      get "set_house_selection_label", :lbl => "a", :id => 'new'        
      controller.send(:labels_ready_to_calculate?).should be_true
    end
  end
  
  describe "calculating the insulation sliders" do
    before(:each) do
      controller.stub!(:render)
      controller.stub!(:update_installation_sliders)
      get "tool"
      get "set_house_selection_label", :lbl => "a", :id => 'existing'        
      get "set_house_selection_label", :lbl => "a", :id => 'new'        
    end
    it "should set the slider 337 value in the session when house_type is new" do
      controller.send(:set_insulation_slider,"a","new")
      session['calculated_hst_sliders']["337"].should_not eql(nil)
    end
    it "should set the slider 336 value in the session when house_type is new" do
      controller.send(:set_insulation_slider,"a","existing")
      session['calculated_hst_sliders']["336"].should_not eql(nil)
    end
  end
  
end
