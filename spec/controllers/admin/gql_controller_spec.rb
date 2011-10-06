require 'spec_helper'

describe Admin::GqlController do

  describe "GET 'search'" do
    it "should be successful" do
      get 'search'
      response.should be_success
    end
  end

end
