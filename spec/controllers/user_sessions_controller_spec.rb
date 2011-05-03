require 'spec_helper'

describe UserSessionsController do
  render_views
  
  
   
  before(:each) do
    stub_etm_layout_methods!
    
    @user = Factory(:user)
    @password = "password"
  end
  
 
  
  context "User is not logged in" do
    it "should get to the login page" do
      get :new
      response.should be_success
      response.should have_selector("form") do |form|
        form.should have_selector("input", :type => "text", :name => "user_session[email]")
        form.should have_selector("input", :type => "password", :name => "user_session[password]")
      end

    end
    
    it "should redirect to admin after succesfull loggin in" do
      post :create, :user_session => {:email => @user.email, :password => @user.password}
      assigns(:user_session).user.should == @user
      response.should redirect_to(root_path)
    end

    it "should render the same page t to admin after unsuccessfull login." do
      post :create, :user_session => {:email => @user.email, :password => 'pssassword'} 
      controller.send(:current_user).should be_nil
      response.should be_success
    end

    
    it "should redirect to redirect_to after loggin in" do
      redirect_to = "/demand"
      get :new, {:redirect_to => redirect_to}
      response.should have_selector("form") do |form|
        form.should have_selector("input", :type => "hidden", :name => "redirect_to", :value => redirect_to)
      end
    end
    
    
    it "should not even render when provided with a weird url" do
      redirect_to = "http://jojo.com"
      get :new, {:redirect_to => redirect_to}
      response.should_not be_success
    end
  end
  
  
  
  context "User is logged in" do
    it "should redirect to the the redirect_to param" do
      controller.stub!(:current_user).and_return(@user)
      get :new, :redirect_to => '/demand'
      response.should redirect_to('/demand')
    end
  end
  
end
