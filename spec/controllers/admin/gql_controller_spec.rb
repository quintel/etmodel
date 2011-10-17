require 'spec_helper'

describe Admin::GqlController do
  before(:each) do
    controller.class.skip_before_filter :restrict_to_admin
  end
  
  describe "GET 'search'" do
    it "should be successful" do
      get 'search'
      response.should be_success
    end
  end

end
