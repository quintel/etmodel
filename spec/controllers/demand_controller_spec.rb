require 'spec_helper'

describe DemandController do
  render_views
  
  describe "GET intro" do
    before do
      Api::Query.any_instance.stub(:fetch_single_value).and_return(1.234)
    end
  
    it "should be successful" do
      get :intro
      response.should be_success
    end
  end
end