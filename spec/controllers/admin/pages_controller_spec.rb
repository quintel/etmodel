require 'spec_helper'

describe Admin::PagesController do
  render_views
  
  let(:admin) { Factory :admin }
  
  before do
    login_as(admin)
  end
  
  describe "GET index" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end
end