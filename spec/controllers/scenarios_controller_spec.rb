require 'rails_helper'

describe ScenariosController, vcr: true do
  render_views

  let(:scenario_mock) { ete_scenario_mock }

  before do
    allow(Api::Scenario).to receive(:find).and_return scenario_mock
  end

  let(:user) { FactoryBot.create :user }
  let(:admin) { FactoryBot.create :admin }
  let!(:user_scenario) { FactoryBot.create :saved_scenario, user: user, id: 648695 }
  let!(:admin_scenario) { FactoryBot.create :saved_scenario, user: admin, id: 648696 }

  context "a guest" do
    describe "#index" do
      it "should be redirected" do
        get :index
        expect(response).to redirect_to(login_url)
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
        expect(response).to be_success
        expect(assigns(:saved_scenarios)).to eq([user_scenario])
      end
    end

    context "with an active scenario" do
      before do
        session[:setting] = Setting.new(api_session_id: 12345)
      end

      describe "#new" do
        it "should show a form to save the scenario" do
          get :new
          expect(response).to be_success
          expect(assigns(:saved_scenario).api_session_id).to eq(12345)
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
          allow(Api::Scenario).to receive(:create).and_return scenario_mock
          expect {
            post :create, params: { saved_scenario: { api_session_id: 12345 } }
            expect(response).to redirect_to(scenarios_path)
          }.to change(SavedScenario, :count)
        end

        it "does not save if no scenario is in progress" do
          expect(Api::Scenario).not_to receive(:create)

          expect {
            post :create, params: { saved_scenario: { api_session_id: '' } }
          }.to_not change(SavedScenario, :count)

          expect(response).to_not be_success
          expect(response).to render_template(:cannot_save_without_id)
        end
      end

      context 'with a scenario for a non-existent region' do
        before do
          session[:setting] = Setting.new(area_code: 'nope')

          expect(Api::Area)
            .to receive(:code_exists?)
            .with('nope').and_return(false)
        end

        it 'resets to the default setting' do
          get :play
          expect(session[:setting].area_code).to eq('nl')
        end
      end

      context 'with a scenario for a existing region' do
        before do
          session[:setting] = Setting.new(area_code: 'de', api_session_id: 123)

          expect(Api::Area)
            .to receive(:code_exists?)
            .with('de').and_return(true)
        end

        it 'does not reset to the default setting' do
          get :play

          expect(session[:setting].area_code).to eq('de')
          expect(session[:setting].api_session_id).to eq(123)
        end
      end

      describe "#reset" do
        it "should reset a scenario" do
          get :reset
          expect(session[:setting].api_session_id).to be_nil
          expect(response).to be_redirect
        end
      end

      describe "#compare" do
        it "should compare them" do
          s1 = FactoryBot.create :saved_scenario
          s2 = FactoryBot.create :saved_scenario
          get :compare, params: { scenario_ids: [s1.id, s2.id] }
          expect(response).to be_success
          expect(response).to render_template(:compare)
        end

        describe 'with a "combine" option' do
          it 'should redirect to Local vs. Global' do
            get :compare, params: { scenario_ids: %w(1 2), combine: '1' }

            expect(response).to redirect_to(
              local_global_scenarios_url("1,2")
            )
          end

          it 'omits invalid IDs' do
            get :compare, params: { scenario_ids: %w(1 no), combine: '1' }

            expect(response).to redirect_to(
              local_global_scenarios_url('1')
            )
          end

          it 'redirects to the landing page when no valid IDs are present' do
            get :compare, params: { scenario_ids: [], combine: '1' }

            expect(response).to redirect_to(scenarios_url)
          end

          it 'redirects to the landing page with no scenario_ids param' do
            get :compare, params: { combine: '1' }

            expect(response).to redirect_to(scenarios_url)
          end
        end
      end

      describe "#weighted_merge" do
        it "should compare them" do
          post :perform_weighted_merge, params: {
            'merge_scenarios' => { '925863' => 1.0, '925864' => 2.0 }
          }

          expect(response).to be_redirect
        end
      end

      describe "#merge" do
        it "should create a remote scenario with the average values" do
          post :merge, params: {
            inputs: 'average',
            inputs_avg: { households_number_of_inhabitants: 1.0 }.to_yaml,
            inputs_def: { households_number_of_inhabitants: 1.0 }.to_yaml
          }

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
        expect(response).to be_success
        expect(assigns(:saved_scenarios)).to include user_scenario
        expect(assigns(:saved_scenarios)).to include admin_scenario
      end
    end
  end

  context "a teacher" do
    before(:each) do
      login_as user
      student= FactoryBot.create(:user, teacher_email: user.email)
      @student_scenario = FactoryBot.create(:saved_scenario, user: student)
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
