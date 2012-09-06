require 'spec_helper'

describe ScenariosController do
  render_views

    let(:scenario_mock) {
      mock = double("api_scenario")
      mock.stub(:id){"123"}
      mock.stub(:title){"title"}
      mock.stub(:end_year){"2050"}
      mock.stub(:parsed_created_at){ Time.now }
      mock.stub(:created_at){ Time.now }
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

#
#  context "User has loaded a scenario" do
#    before(:each) do
#      Current.stub!(:scenario).and_return(@scenario)
#    end
#
#    describe "#reset_to_preset" do
#      context "Scenario has a preset" do
#        before(:each) do
#          @preset = Factory(:scenario)
#          @preset.user_values = {3 => 4}
#          @preset.save
#          @scenario.preset_scenario = @preset
#          @scenario.user_values = {1 => 2}
#          @scenario.save
#          request.env["HTTP_REFERER"] = '/'
#        end
#
#        it "should be able to do a post to a public preset if it has set one" do
#          @scenario.user_values.should == {1 => 2}
#          @scenario.preset_scenario.user_values.should == {3 => 4}
#          post :reset_to_preset
#          response.should be_redirect
#          , :use_peak_load => true.user_values.should == {3 => 4}
#        end
#      end
#
#
#      context "Scenario has no preset" do
#        before(:each) do
#          request.env["HTTP_REFERER"] = '/'
#        end
#
#        it "should not be able to do a post if it has no preset scenario" do
#          post :reset_to_preset
#          response.status.should == 403
#        end
#      end
#    end
#
#    describe "#edit" do
#      context "not logged in" do
#        it "should not display the edit form" do
#          get :edit
#          response.status.should == 403
#        end
#      end
#
#      context "logged in" do
#        before(:each) do
#          log_in(@user)
#        end
#
#        it "should just get edit" do
#          get :edit
#          response.should be_success
#          assigns['scenario'].should == Current.scenario
#        end
#      end
#    end
#
#    describe "#update" do
#      it "should save the user values when they are updated" do
#        request.env["HTTP_REFERER"] = '/'
#        Current.scenario.user_values = {'2' => '3'}
#        put :update
#        assigns['scenario'].reload.user_values.should == {'2' => '3'}
#        response.should be_redirect
#      end
#    end
#  end
#
#
#  context "user has not loaded a scenario" do
#    before(:each) do
#      @scenario = Factory(:scenario)
#      @scenario.user_values = {'2' => '3'}
#      @scenario.save
#    end
#
#    describe "#load" do
#      it "should redirect after get" do
#        get :load, {:id => @scenario.id}
#        response.should be_redirect
#      end
#
#      it "should set Current.scenario after get"
#    end
#
end
