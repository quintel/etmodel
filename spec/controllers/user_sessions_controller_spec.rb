require 'spec_helper'

describe UserSessionsController, type: :controller do
  render_views

  before(:each) do
    @user = FactoryGirl.create :user
  end

  context "User is not logged in" do
    it "should get to the login page" do
      get :new
      response.should be_success
      response.body.should have_selector("form") do |form|
        form.should have_selector("input", :type => "text", :name => "user_session[email]")
        form.should have_selector("input", :type => "password", :name => "user_session[password]")
      end
    end

    it "should redirect to admin after succesfull login in" do
      post :create, :user_session => {:email => @user.email, :password => @user.password}
      assigns(:user_session).user.should == @user
      response.should redirect_to(root_path)
    end

    it "should render the same page to admin after unsuccessfull login." do
      post :create, :user_session => {:email => @user.email, :password => 'pssassword'}
      controller.send(:current_user).should be_nil
      response.should be_success
    end
  end
end
