require 'spec_helper'

describe CostsController do
  render_views
    
  describe "GET intro" do
    it "should be successful" do
      get :intro
      response.should be_success
    end
  end

  describe "GET show" do
    it "should be successful" do
      controller.class.skip_before_filter :show_intro_at_least_once
      get :show
      response.should be_success
      response.should render_template('show')
    end
  end
end