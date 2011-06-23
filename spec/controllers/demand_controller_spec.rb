require 'spec_helper'

describe DemandController do
  render_views
  
  describe "GET intro" do
    before do
      Api::Client.any_instance.stub(:simple_query).and_return(1.234)
    end
  
    it "should be successful" do
      get :intro
      response.should be_success
    end
  end
end