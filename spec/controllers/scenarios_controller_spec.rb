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
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }
  let(:mock_token) { 'mocked-token' }
  let(:user_scenario) do
    double('SavedScenario',
           id: 648_695,
           user: user,
           scenario: double('Scenario', loadable?: true))
  end

  let(:admin_scenario) do
    double('SavedScenario',
           id: 648_696,
           user: admin,
           scenario: double('Scenario', loadable?: true))
  end

  before do
    allow(FetchAPIScenario).to receive(:call).and_return(ServiceResult.success(scenario_mock))
    allow(ETModel::TokenDecoder).to receive(:fetch_token).and_return(mock_token)
    allow(Identity).to receive(:http_client).and_return(double('HTTPClient'))
  end

  context 'with a guest' do
    describe '#index' do
      it 'is redirected' do
        get :index
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end

  describe '#play' do
    let(:slide) { sidebar_item.slides.first }

    before do
      session[:setting] = Setting.new(area_code: 'nl', api_session_id: 123)

      allow(Engine::Area)
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
      sign_in user
    end

    # rubocop:disable RSpec/NestedGroups
    context 'with an active scenario' do
      before do
        session[:setting] = Setting.new(api_session_id: 12_345)
      end

      describe '#show' do

        context 'with a non-existent scenario' do
          before do
            allow(FetchAPIScenario)
              .to receive(:call)
              .and_return(ServiceResult.failure('Scenario not found'))
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

          allow(Engine::Area)
            .to receive(:code_exists?)
            .with('nope').and_return(false)
        end

        pending 'resets to the default setting' do
          get :play
          expect(session[:setting].area_code).to eq(Setting.default_attributes[:area_code])
        end
      end

      context 'with a scenario for a existing region' do
        subject do
          session[:setting] = Setting.new(area_code: 'de', api_session_id: 123)
          allow(Engine::Area)
            .to receive(:code_exists?)
            .with('de').and_return(true)
          get :play

          session[:setting]
        end

        pending 'retains the area code' do
          expect(subject.area_code).to eq('de')
        end

        pending 'retains the api session id' do
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

          it 'sets the area code' do
            scenario_mock = ete_scenario_mock

            allow(scenario_mock).to receive(:id).and_return('456')
            allow(scenario_mock).to receive(:area_code).and_return('some_code')

            allow(FetchAPIScenario)
              .to receive(:call)
              .and_return(ServiceResult.success(scenario_mock))

            get :play_multi_year_charts, params: { id: 456 }
            expect(session[:setting].area_code).to eq('some_code')
          end

          it 'opens the play page' do
            get :play_multi_year_charts, params: { id: 123 }
            expect(response).to render_template(:play)
          end
        end

        context 'with an invalid scenario' do
          before do
            allow(FetchAPIScenario)
              .to receive(:call)
              .and_return(ServiceResult.failure('Scenario not found'))
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

        context 'with a valid input name' do
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

      describe 'POST #update_couplings' do
        before do
          allow(UncoupleAPIScenario).to receive(:call).and_return(ServiceResult.success)
          session[:setting] = Setting.new(coupling: true)
        end

        context 'when remove_all_couplings is present' do
          subject do
            post :update_couplings, params: { id: 123, remove_all_couplings: '1' }
            response
          end

          it 'calls the UncoupleAPIScenario service' do
            subject
            expect(UncoupleAPIScenario).to have_received(:call).with(anything, '123', soft: false)
          end

          it 'updates the session settings to uncoupled' do
            subject
            expect(session[:setting].coupling).to be_falsey
          end

          it { is_expected.to be_redirect }
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

      describe '#update_couplings' do
        before do
          allow(UncoupleAPIScenario).to receive(:call).and_return(ServiceResult.success(scenario_mock))
          allow(RecoupleAPIScenario).to receive(:call).and_return(ServiceResult.success(scenario_mock))
          session[:setting].active_couplings = ['group2']
          session[:setting].inactive_couplings = ['group1']
        end

        context 'when remove_all_couplings is present' do
          it 'removes all couplings' do
            post :update_couplings, params: { id: 123, remove_all_couplings: '1' }

            expect(session[:setting].coupling).to be_falsey
            expect(UncoupleAPIScenario).to have_received(:call).with(anything, '123', {soft: false})
          end
        end

        context 'when couplings are provided' do
          let(:request) do
            post :update_couplings, params: {
              id: user_scenario.id,
              couplings: {
                'group1' => '1',
                'group2' => '0'
              }
            }
          end

          it 'activates and deactivates the correct couplings' do
            request
            expect(RecoupleAPIScenario).to have_received(:call).with(anything, '123', ['group1'])
            expect(UncoupleAPIScenario).to have_received(:call).with(anything, '123', ['group2'], {soft: true})
          end

          it 'activates the coupling in the settings' do
            request
            expect(session[:setting].active_couplings).to include('group1')
          end

          it 'deactivates the coupling in the settings' do
            request
            expect(session[:setting].inactive_couplings).to include('group2')
          end
        end
      end
    end

    context 'when loading the resume play endpoint' do # TODO
      # Rendering the view triggers requests to ETEngine.
      render_views false

      before do
        session[:setting] = Setting.new(api_session_id: 12_345)
      end

      context 'with a valid scenario' do
        before do
          allow(FetchAPIScenario)
            .to receive(:call)
            .and_return(ServiceResult.success(scenario_mock))
        end

        it 'sets the API session ID' do
          get :resume, params: { id: 123 }
          expect(session[:setting].api_session_id).to eq('123')
        end

        it 'redirects to the play page' do
          get :resume, params: { id: 123 }
          expect(response).to redirect_to(play_path)
        end
      end

      context 'with an invalid scenario' do
        before do
          allow(FetchAPIScenario)
            .to receive(:call)
            .and_return(ServiceResult.failure('Scenario not found'))
        end

        it 'does not set the API session ID' do
          expect { get(:resume, params: { id: 123 }) }
            .not_to change(session[:setting], :api_session_id)
        end

        it 'redirects to the root page' do
          get :resume, params: { id: 123 }
          expect(response).to redirect_to(root_url)
        end
      end
    end
    # rubocop:enable RSpec/NestedGroups
  end
end
