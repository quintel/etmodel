require 'spec_helper'

describe ScenariosController, :vcr => true do
  render_views

  let(:scenario_mock) {
    mock = double("api_scenario")
    mock.stub(:id){"123"}
    mock.stub(:title){"title"}
    mock.stub(:end_year){"2050"}
    mock.stub(:area_code){"nl"}
    mock.stub(:parsed_created_at){ Time.now }
    mock.stub(:created_at){ Time.now }
    mock.stub(:all_inputs){ {} }
    mock
  }

  before do
    Api::Scenario.stub!(:find).and_return scenario_mock
  end

  let(:user) { FactoryGirl.create :user }
  let(:admin) { FactoryGirl.create :admin }
  let!(:user_scenario) { FactoryGirl.create :saved_scenario, :user => user }
  let!(:admin_scenario) { FactoryGirl.create :saved_scenario, :user => admin }

  context "a guest" do
    describe "#index" do
      it "should be redirected" do
        get :index
        response.should redirect_to(login_url)
      end
    end
  end

  context "a regular user" do
    before do
      login_as user
    end

    describe "#index" do
      it "should get a list of his saved scenarios" do
        get :index
        response.should be_success
        assigns(:saved_scenarios).should == [user_scenario]
      end
    end

    context "with an active scenario" do
      before do
        session[:setting] = Setting.new(:api_session_id => 12345)
      end

      describe "#new" do
        it "should show a form to save the scenario" do
          get :new
          response.should be_success
          assigns(:saved_scenario).api_session_id.should == 12345
        end
      end

      describe "#create" do
        it "should save a scenario" do
          Api::Scenario.stub!(:create).and_return scenario_mock
          lambda {
            post :create, :saved_scenario => {:api_session_id => 12345}
            response.should redirect_to(scenarios_path)
          }.should change(SavedScenario, :count)
        end
      end

      describe "#reset" do
        it "should reset a scenario" do
          get :reset
          session[:setting].api_session_id.should be_nil
          response.should be_redirect
        end
      end

      describe "#compare" do
        it "should compare them" do
          s1 = FactoryGirl.create :saved_scenario
          s2 = FactoryGirl.create :saved_scenario
          get :compare, :scenario_ids => [s1.id, s2.id]
          expect(response).to be_success
          expect(response).to render_template(:compare)
        end
      end

      describe "#merge" do
        it "should create a remote scenario with the average values" do
          post :merge, :inputs => {:households_number_of_inhabitants => 1.0}
            expect(response).to be_success
        end
      end
    end
  end

  context "an admin" do
    before do
      login_as admin
    end

    describe "#index" do
      it "should get a list of all saved scenarios" do
        get :index
        response.should be_success
        assigns(:saved_scenarios).to_set.should == [user_scenario, admin_scenario].to_set
      end
    end
  end
end
