require 'spec_helper'

describe CostsController do
  render_views
    
  describe "GET show" do
    it "should be successful" do
      get :show
      response.should be_success
      response.should render_template('show')
    end
  end
end