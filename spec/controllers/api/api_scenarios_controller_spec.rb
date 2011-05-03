require 'spec_helper'

describe Api::ApiScenariosController do

  before(:each) do
    stub_etm_layout_methods!
    Current.stub_chain(:gql, :query).and_return Gql::GqueryResult.create([[2010,1],[2010,2]])
  end
  
  describe "index" do
    it "should render" do
      get 'index'
    end
  end

  describe "new" do
    it "should create a new ApiScenario" do
      expect {
        get 'new'
      }.to change(ApiScenario, :count).by(1)
      response.should be_redirect
    end

    it "should create and assign params[:settings]" do
      api_session_key = Time.now.to_i

      expect {
        get :new, {:settings => {:country => 'uk', :api_session_key => api_session_key}}
      }.to change(ApiScenario, :count).by(1)

      ApiScenario.find_by_api_session_key(api_session_key).should_not be_nil
      response.should be_redirect
    end
  end

  describe "show" do
    before(:all) do
      @api_scenario = ApiScenario.create(Scenario.default_attributes.merge(:title => 'foo', :api_session_key => 'foo'))
    end

    it "should assign @api_scenario" do
      get :show, :id => @api_scenario.api_session_key
      assigns(:api_scenario).api_session_key.should == @api_scenario.api_session_key
    end

    it "should get results" do
      Gquery.stub!(:get).and_return(mock_model(Gquery, :key => 'gquery_key'))
      get :show, :id => @api_scenario.api_session_key, 'result[]' => 'gquery_key', 'result[]' => 'gquery_key2'
      assigns(:results).values.should have(2).items
    end
  end

end