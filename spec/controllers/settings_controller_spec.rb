require 'spec_helper'

describe SettingsController do
  describe "GET /settings/backcasting" do
    it "should set a session variable" do
      session[:backcasting_enabled].should be_nil
      get :backcasting
      session[:backcasting_enabled].should be_true
      response.should redirect_to(root_path)
    end
  end
end
