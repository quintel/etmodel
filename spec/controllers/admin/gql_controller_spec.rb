require 'spec_helper'

describe Admin::GqlController, type: :controller do
  before(:each) do
    login_as(FactoryGirl.create(:admin))
  end

  describe "GET 'search'" do
    it "should be successful" do
      get 'search'
      response.should have_http_status(:success)
    end
  end

end
