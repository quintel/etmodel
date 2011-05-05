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
    it "should replace output element partial" do
      pending "Robbert fix this."
      #post "change",:id=> "1", :selected => false
      #assert_select_rjs :replace_html, "#charts_holder"
    end
  end
end
