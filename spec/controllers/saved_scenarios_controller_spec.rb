require 'rails_helper'

describe SavedScenariosController, vcr: true do
  render_views

  let(:scenario_mock) { ete_scenario_mock }
  let(:client) { Faraday.new(url: 'http://et.engine') }

  let(:user) { FactoryBot.create :user }
  let(:admin) { FactoryBot.create :admin }

  before do
    allow(ETModel::Clients).to receive(:idp_client).and_return(client)
    allow(ETModel::Clients).to receive(:engine_client).and_return(client)
    allow(FetchAPIScenario).to receive(:call).and_return(ServiceResult.success(ete_scenario_mock))
    allow(CreateAPIScenario).to receive(:call).and_return(ServiceResult.success(ete_scenario_mock))
  end

  context 'a regular user' do
    before do
      sign_in user
      session[:setting] = Setting.new
    end

    describe 'GET load' do
      context 'with an owned saved_scenario' do
        subject { response }

        before { get(:load, params: { id: 12, scenario_id: 10 }) }

        it { is_expected.to redirect_to play_path }

        it do
          expect(session[:setting].active_saved_scenario_id).to eq(12)
        end

        it do
          expect(session[:setting].api_session_id).to eq(ete_scenario_mock.id)
        end
      end

      context 'when the saved scenario was already active' do
        subject { response }

        before do
          session[:setting].active_saved_scenario_id = 12
          session[:setting].api_session_id = 100_000
          get(:load, params: { id: 12, scenario_id: 10 })
        end

        it { is_expected.to redirect_to play_path }

        it 'does not update the scenario (session) id' do
          expect(session[:setting].api_session_id).to eq(100_000)
        end
      end

      it 'changes the session active_saved_scenario_id in settings' do
        expect do
          get :load, params: { id: 12, scenario_id: 10 }
        end.to change{ session[:setting].active_saved_scenario_id }
                .from(nil)
                .to 12
      end

      it 'with a non-existent scenario redirects to #show' do
        allow(CreateAPIScenario)
          .to receive(:call)
          .and_return(ServiceResult.failure('Scenario not found'))

        get :load, params: { id: 1, scenario_id: 11 }
        expect(response).to be_redirect
      end
    end
  end

  pending ' GET show' do
    pending "RECHECK"

    it 'has an ok status' do
      get :show, params: { id: 1 }
      expect(response).to be_successful
    end

    it 'responds to the .csv format' do
      get :show, params: { id: 1 }, format: :csv
      expect(response.media_type).to eq('text/csv')
    end

    context 'when the scenario cannot be loaded' do
      before do
        allow(Engine::Area).to receive(:code_exists?).and_return(false)
      end

      it 'redirects to the root page' do
        get :show, params: { id: 1 }
        expect(response).to be_redirect
      end
    end
  end

  describe 'GET new' do
    it 'renders the new saved scenario form' do
      sign_in(user)
      get :new, params: { scenario_id: 1 }

      expect(response).to be_ok
    end
  end

  pending 'POST create' do
    pending 'RECHECK'
    before do
      sign_in(user)

      allow(CreateAPIScenario).to receive(:call).and_return(
        ServiceResult.success(Engine::Scenario.new(
          attributes_for(:engine_scenario, id: 999, area_code: 'nl', end_year: 2050)
        ))
      )
      allow(CreateSavedScenario).to receive(:call).and_return(
        ServiceResult.success({ saved_scenario: { id: 12 }}
      ))
    end

    context 'with valid attributes' do
      let(:request) do
        session[:setting] = Setting.new

        post :create, params: {
          saved_scenario: { title: 'My first scenario', scenario_id: 1 }
        }
      end

      it 'creates a new SavedScenario' do
        request
        expect(session[:setting][:active_saved_scenario_id]).to eq(12)
      end

      it 'sets the scenario ID' do
        request
        expect(session[:setting][:api_session_id]).to eq(1)
      end

      it 'redirect to the scenario' do
        expect(request).to redirect_to(play_path)
      end
    end

    context 'with invalid attributes' do
      let(:request) do
        post :create, params: {
          saved_scenario: { scenario_id: 1 }
        }
      end

      it 'does not create a new SavedScenario' do
        expect { request }.not_to change(session[:setting][:api_session_id])
      end

      it 'renders the form' do
        expect(request).to render_template(:new)
      end
    end
  end

  pending 'PUT update' do
    pending 'TODO REWRITE!!!'

    let(:update) do
      put :update, format: :json, params: {
        id: 12,
        scenario_id: 1
      }
    end

    # TODO: FIX AND REWRITE
    context 'with an owned saved_scenario' do
      before do
        sign_in user
        session[:setting] = Setting.new

        allow(UpdateSavedScenario).to receive(:call).and_return(
          ServiceResult.success({ saved_scenario: { id: 12 }}
        ))

        update
      end

      it 'does not update the title' do
        expect(user_scenario.title).not_to eq(params[:title])
      end
    end

    context 'with an owned saved_scenario and a new title and description' do
      before do
        sign_in user
        session[:setting] = Setting.new

        allow(UpdateSavedScenario).to receive(:call).and_return(
          ServiceResult.success({ saved_scenario: { id: 12 }}
        ))

        update
      end

      let(:params) do
        {
          title: 'New title',
          description: 'New description'
        }
      end

      it 'updates the title' do
        expect(user_scenario.title).to eq(params[:title])
      end

      it 'updates the description' do
        expect(user_scenario.description).to eq(params[:description])
      end
    end
  end
end
