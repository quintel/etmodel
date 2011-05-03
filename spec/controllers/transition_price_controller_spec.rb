require 'spec_helper'

describe TransitionPriceController do
  describe "/index" do
    it "should get the index" do
      get :index
      response.should be_success 
    end
  end

  
  describe "/intro" do
    context "When getting the page" do
      it "should get intro page" do
        get :intro
        response.should be_success
      end
    end
  
    context "When posting the page" do
      it "should create a user" do
        user = User.new
        user.stub!(:save).and_return(true)
        User.stub!(:new).and_return(user)
        post :intro, {:user => {:name => "Test"}}
        response.should redirect_to(:action => 'load_scenario', :redirect_to => "/transitiejaarprijs/intro/2")
      end
    end
  end
  
  
  describe "/login_and_load_scenario" do
    context "valid user" do
      before(:each) do
        @user_session = UserSession.new
        @user_session.stub!(:save).and_yield(true)
        UserSession.stub!(:new).and_return(@user_session)
      end
    
      it "should redirect to load scenario" do
        post :login_and_load_scenario
        response.should redirect_to(:action => 'load_scenario')
      end
    end
    
    context "invalid user" do
      before(:each) do
        @user_session = UserSession.new
        @user_session.stub!(:save).and_yield(false)
        UserSession.stub!(:new).and_return(@user_session)
      end
    
      it "should redirect to load scenario" do
        post :login_and_load_scenario
        response.should redirect_to(:action => 'index')
      end
      
    end
  end
  
  describe "/intro/2" do
    it "should get second intro page" do
      get :intro_2
      response.should be_success
    end
  end
  

  describe "/load_scenario" do
    before(:each) do
      log_in(Factory(:user))
      @preset = Factory.build(:scenario)
      @preset.scenario_type = "transition_price_preset"
      @preset.save
    end
    
    
    it "should get load scenario and redirect" do
      expect {
        get :load_scenario
      }.to change(Scenario, :count).by(1)
      
      response.should redirect_to(load_scenario_path(:id => Scenario.last.id))
    end
  end  
  

end
