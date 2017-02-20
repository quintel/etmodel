require 'spec_helper'

describe ScenariosController, type: :controller, vcr: true do
  render_views

  let(:scenario_mock) { ete_scenario_mock }

  before do
    Api::Scenario.stub(:find).and_return scenario_mock
  end

  let(:user) { FactoryGirl.create :user }
  let(:admin) { FactoryGirl.create :admin }
  let!(:user_scenario) { FactoryGirl.create :saved_scenario, user: user }
  let!(:admin_scenario) { FactoryGirl.create :saved_scenario, user: admin }

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
        session[:setting] = Setting.new(api_session_id: 12345)
      end

      describe "#new" do
        it "should show a form to save the scenario" do
          get :new
          response.should be_success
          assigns(:saved_scenario).api_session_id.should == 12345
        end

        it "raises an error if no scenario is in progress" do
          session[:setting] = Setting.default

          get :new

          expect(response).to_not be_success
          expect(response).to render_template(:cannot_save_without_id)
        end
      end

      describe "#create" do
        it "should save a scenario" do
          Api::Scenario.stub(:create).and_return scenario_mock
          lambda {
            post :create, saved_scenario: {api_session_id: 12345}
            response.should redirect_to(scenarios_path)
          }.should change(SavedScenario, :count)
        end

        it "does not save if no scenario is in progress" do
          Api::Scenario.should_not_receive(:create)

          expect {
            post :create, saved_scenario: {api_session_id: ''}
          }.to_not change(SavedScenario, :count)

          expect(response).to_not be_success
          expect(response).to render_template(:cannot_save_without_id)
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
          get :compare, scenario_ids: [s1.id, s2.id]
          expect(response).to be_success
          expect(response).to render_template(:compare)
        end
      end

      describe "#merge" do
        it "should create a remote scenario with the average values" do
          post :merge,
            inputs: 'average',
            inputs_avg: {households_number_of_inhabitants: 1.0}.to_yaml,
            inputs_def: {households_number_of_inhabitants: 1.0}.to_yaml
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
        assigns(:saved_scenarios).should include user_scenario
        assigns(:saved_scenarios).should include admin_scenario
      end
    end
  end

  context "a teacher" do
    before(:each) do
      login_as user
      student= FactoryGirl.create(:user, teacher_email: user.email)
      @student_scenario = FactoryGirl.create(:saved_scenario, user: student)
    end

    describe "#index" do
      it "gets a list of teacher's and students' scenarios" do
        get :index
        expect(response).to be_success
        expect(assigns(:saved_scenarios)).to_not include(admin_scenario)

        expect(assigns(:saved_scenarios).length).to eql(2)

        expect(assigns(:saved_scenarios)).to include(user_scenario)
        expect(assigns(:saved_scenarios)).to include(@student_scenario)
      end
    end
  end

end
