require 'spec_helper'


class RescueController < ApplicationController
  def method_not_implemented
    raise ActionController::NotImplemented.new
  end
  
  def method_not_allowed
    raise ActionController::MethodNotAllowed.new
  end
  

  def record_not_found
    raise ActiveRecord::RecordNotFound.new
  end
   
  
  def routing_error
    raise ActionController::RoutingError.new('test')
  end
  
  def runtime_error
    raise "Some random error"
  end
end


describe RescueController do
  # TODO jaap fix this. breaks the test
  #controller_name :rescue
  render_views
  
  
  before(:each) do
    ApplicationController.stub!(:ensure_valid_browser)
    Current.stub!(:graph)
    # @controller = RescueController.new
    # RescueController.consider_all_requests_local = false
    # @request.host = 'example.com'
    # @request.remote_addr = '1.2.3.4'
  end
  
  context "methods that should handle 405 error" do
    it "handles a method that raises an NotImplemented error with an MethodNotAllowed template" do
      get 'method_not_implemented'
      
      response.response_code.should == 405
    end
  
  
    it "handles a method that raises an ActiveRecordNotFound error with an NotFound template" do
      get :method_not_allowed
      # response.layout.should == "layouts/pages"
      response.response_code.should == 405
    end
  end  
  
  
  context "methods that should handle 404 error" do
    it "handles a method that raises an ActiveRecordNotFound error with an NotFound template" do
      get :record_not_found
      # response.layout.should == "layouts/pages"
      response.response_code.should == 404
    end
  
    it "handles a method that raises an RoutingError with a NotFound template" do
      get :routing_error
      # response.layout.should == "layouts/pages"
      response.response_code.should == 404
    end
  end
  
  
  it "should handle a RuntimeError with a 500 error" do

    #$TESTING = true
    #get :runtime_error
    # controller.layout.should == "layouts/pages"
    #response.response_code.should == 500
  end
  
  
  
end