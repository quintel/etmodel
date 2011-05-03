require 'spec_helper'

describe OutputElementsController do
  render_views

  before(:each) do
    ApplicationController.stub!(:ensure_valid_browser)
    Current.stub!(:graph)
    @output_element = OutputElement.new 
    OutputElement.stub!(:find).and_return(@output_element)
    @output_element.stub_chain(:output_element_type,:name).and_return('name')
    @output_element.stub!(:html_table?).and_return(false)
  end
  
  describe "change" do
    it "should set the session[selected_output_element] with the selected output_element_id " do
      id = "1"
      post "change",:id=> id, :selected => true
      session[:selected_output_element].should eql(id.to_s)
    end
  
    it "should set the keep_selected session with the selected id if the checkbox is checked" do
      post "change", :id=> "1", :selected => true,:keep => true
      session[:keep_selected_output_element].should be_true
    end
  
    it "should clear the selected en keep_selected sessions when changing to default output_element" do
      id = 2
      post "change",:id=>id, :selected =>"default"
      session[:keep_selected_output_element].should be_false
      session[:selected_output_element].should eql(nil)
    end
  
    it "should replace output element partial" do
      pending "Robbert fix this."
      #post "change",:id=> "1", :selected => false
      #assert_select_rjs :replace_html, "#charts_holder"
    end
  end
end
