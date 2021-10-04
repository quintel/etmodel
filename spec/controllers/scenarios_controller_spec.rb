# frozen_string_literal: true

require 'rails_helper'

describe ScenariosController, vcr: true do
  render_views

  # Interface elements
  let(:tab) { Tab.find_by_key(Interface::DEFAULT_TAB) }
  let(:second_tab) { Tab.all.second }
  let(:sidebar_item) { tab.sidebar_items.first }
  let(:second_sidebar_item) { second_tab.sidebar_items.second }
  # Scenarios
  let(:scenario_mock) { ete_scenario_mock }
  let(:user) { FactoryBot.create :user }
  let(:admin) { FactoryBot.create :admin }
  let!(:user_scenario) do
    FactoryBot.create :saved_scenario, user: user, id: 648_695
  end
  let!(:admin_scenario) do
    FactoryBot.create :saved_scenario, user: admin, id: 648_696
  end

  before do
    allow(Api::Scenario).to receive(:find).and_return scenario_mock
  end

  context 'with a guest' do
    describe '#index' do
      it 'is redirected' do
        get :index
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe '#play' do
    let(:slide) { sidebar_item.slides.first }

    before do
      session[:setting] = Setting.new(area_code: 'nl', api_session_id: 123)

      allow(Api::Area)
        .to receive(:find_by_country_memoized)
        .and_return(FactoryBot.build(:api_area))
    end

    context 'with no tab, sidebar, or slide params' do
      it 'loads the page' do
        get :play
        expect(response).to be_successful
      end
    end

    context 'with valid tab, sidebar, and slide params' do
      it 'loads the page' do
        get :play, params: {
          tab: tab.key,
          sidebar: sidebar_item.key,
          slide: slide.short_name
        }

        expect(response).to be_successful
      end
    end
  end

  context 'with a registered user' do
    before do
      login_as user
    end

    describe '#index' do
      before do
        get :index
      end

      it { expect(response).to be_successful }
      it 'gets the users saved scenario' do
        expect(assigns(:saved_scenarios)).to eq([user_scenario])
      end
    end

    # rubocop:disable RSpec/NestedGroups
    # TODO: Refactor thi
    context 'with an active scenario' do
      before do
        session[:setting] = Setting.new(api_session_id: 12_345)
      end

      describe '#show' do
        context 'with a loadable scenario' do
          subject do
            get :show, params: { id: user_scenario.id }
            response
          end

          it { is_expected.to be_successful }
          it { is_expected.to render_template(:show) }
          it 'calls loadable?' do
            subject
            expect(user_scenario.scenario).to have_received(:loadable?)
          end
        end

        context 'with a not-loadable scenario' do
          subject do
            allow(user_scenario.scenario)
              .to receive(:loadable?)
              .and_return(false)
            get :show, params: { id: user_scenario.id }
            response
          end

          it { is_expected.to be_redirect }
        end

        context 'with a non-existent scenario' do
          before do
            allow(Api::Scenario)
              .to receive(:find)
              .and_raise(ActiveResource::ResourceNotFound.new(nil))
          end

          it 'shows information about the scenario' do
            get :show, params: { id: user_scenario.id }
            expect(response).to be_redirect
          end
        end
      end

      context 'with a scenario for a non-existent region' do
        before do
          session[:setting] = Setting.new(area_code: 'nope')

          allow(Api::Area)
            .to receive(:code_exists?)
            .with('nope').and_return(false)
        end

        it 'resets to the default setting' do
          get :play
          expect(session[:setting].area_code).to eq(Setting.default_attributes[:area_code])
        end
      end

      context 'with a scenario for a existing region' do
        subject do
          session[:setting] = Setting.new(area_code: 'de', api_session_id: 123)
          allow(Api::Area)
            .to receive(:code_exists?)
            .with('de').and_return(true)
          get :play

          session[:setting]
        end

        it 'retains the area code' do
          expect(subject.area_code).to eq('de')
        end

        it 'retains the api session id' do
          expect(subject.api_session_id).to eq(123)
        end
      end

      context 'when loading the MYC play endpoint' do
        # Rendering the view triggers requests to ETEngine.
        render_views false

        context 'with a valid scenario' do
          it 'sets the API session ID' do
            get :play_multi_year_charts, params: { id: 123 }
            expect(session[:setting].api_session_id).to eq('123')
          end

          it 'opens the play page' do
            get :play_multi_year_charts, params: { id: 123 }
            expect(response).to render_template(:play)
          end
        end

        context 'with an invalid scenario' do
          before do
            allow(Api::Scenario)
              .to receive(:find)
              .and_raise(ActiveResource::ResourceNotFound.new(nil))
          end

          it 'does not set the API session ID' do
            expect { get(:play_multi_year_charts, params: { id: 123 }) }
              .not_to change(session[:setting], :api_session_id)
          end

          it 'redirects to the root page' do
            get :play_multi_year_charts, params: { id: 123 }
            expect(response).to redirect_to(root_url)
          end
        end

        context 'with a valid input named' do
          let(:input) do
            second_sidebar_item.slides.first.sliders.first
          end

          it 'opens the play page' do
            get :play_multi_year_charts, params: { id: 123, input: input.key }
            expect(response).to render_template(:play)
          end

          it 'sets the last_etm_page URL' do
            get :play_multi_year_charts, params: { id: 123, input: input.key }

            expect(session[:setting].last_etm_page)
              .to eq(play_url(*input.url_components))
          end
        end

        context 'with an invalid input named' do
          it 'opens the play page' do
            get :play_multi_year_charts, params: { id: 123, input: 'hello' }
            expect(response).to render_template(:play)
          end

          it 'does not set the last_etm_page URL' do
            get :play_multi_year_charts, params: { id: 123, input: 'hello' }
            expect(session[:setting].last_etm_page).to be_nil
          end
        end
      end

      describe '#reset' do
        subject do
          get :reset
          response
        end

        it { is_expected.to be_redirect }
        it 'resets the session settings' do
          subject
          expect(session[:setting].api_session_id).to be_nil
        end
      end

      describe '#compare' do
        subject do
          s1 = FactoryBot.create :saved_scenario
          s2 = FactoryBot.create :saved_scenario
          get :compare, params: {
            scenario_ids: [s1.scenario_id, s2.scenario_id]
          }
          response
        end

        it { is_expected.to be_successful }
        it { is_expected.to render_template(:compare) }

        describe 'with a "combine" option' do
          it 'redirects to Local vs. Global' do
            get :compare, params: { scenario_ids: %w[1 2], combine: '1' }

            expect(response).to redirect_to(
              local_global_scenarios_url('1,2')
            )
          end

          it 'omits invalid IDs' do
            get :compare, params: { scenario_ids: %w[1 no], combine: '1' }

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

      describe '#weighted_merge' do
        it 'compares them' do
          post :perform_weighted_merge, params: {
            'merge_scenarios' => { '925863' => 1.0, '925864' => 2.0 }
          }

          expect(response).to be_redirect
        end
      end

      describe '#merge' do
        it 'creates a remote scenario with the average values' do
          post :merge, params: {
            inputs: 'average',
            inputs_avg: { households_number_of_inhabitants: 1.0 }.to_yaml,
            inputs_def: { households_number_of_inhabitants: 1.0 }.to_yaml
          }

          expect(response).to be_successful
        end
      end
    end
    # rubocop:enable RSpec/NestedGroups
  end

  context 'with an admin' do
    before do
      login_as admin
    end

    describe '#index' do
      subject do
        get :index
        response
      end

      it { is_expected.to be_successful }
      it 'gets a list of all saved scenarios' do
        subject
        expect(assigns(:saved_scenarios))
          .to include user_scenario, admin_scenario
      end
    end
  end

  context 'with a teacher' do
    let(:student) { FactoryBot.create(:user, teacher_email: user.email) }
    let(:student_scenario) { FactoryBot.create(:saved_scenario, user: student) }

    before do
      login_as user
      student_scenario
    end

    describe '#index' do
      subject do
        get :index
        response
      end

      it { is_expected.to be_successful }
      it 'shows only the teachers and their students scenarios' do
        subject
        expect(assigns(:saved_scenarios))
          .to contain_exactly(user_scenario, student_scenario)
      end
    end
  end

  describe 'PUT update' do
    context 'with a scenario ID' do
      let(:request) { put(:update, params: { id: user_scenario.id, scenario_id: 99 }) }

      before do
        allow(UpdateSavedScenario).to receive(:call).and_return(ServiceResult.success('123'))
      end

      it 'changes the scenario_id of the saved scenario' do
        request
        expect(UpdateSavedScenario).to have_received(:call).with(user_scenario, 99)
      end

      it 'returns the saved scenario JSON' do
        request
        expect(JSON.parse(response.body)).to eq(JSON.parse(user_scenario.to_json))
      end
    end

    context 'with the scenario ID missing' do
      let(:request) { put(:update, params: { id: user_scenario.id }) }

      it 'raises an error' do
        expect { request }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end
end
