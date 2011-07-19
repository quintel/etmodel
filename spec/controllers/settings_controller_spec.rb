require 'spec_helper'

describe SettingsController do
  describe "GET /settings/backcasting" do
    it "should set a session variable" do
      session[:enable_backcasting].should be_nil
      get :backcasting
      session[:enable_backcasting].should be_true
      response.should redirect_to(root_path)
    end
  end
end
