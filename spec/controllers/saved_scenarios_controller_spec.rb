require 'rails_helper'

describe SavedScenariosController, vcr: true do
  render_views

  let(:scenario_mock) { ete_scenario_mock }
  let(:client) { Faraday.new(url: 'http://et.engine') }
  let(:user) { FactoryBot.create :user }
  let(:admin) { FactoryBot.create :admin }

  before do
    allow(FetchAPIScenario).to receive(:call).and_return(ServiceResult.success(ete_scenario_mock))
    allow(CreateAPIScenario).to receive(:call).and_return(ServiceResult.success(ete_scenario_mock))
  end

  context 'a regular user' do
    before do
      sign_in user
      session[:setting] = Setting.new
    end

    describe 'GET load' do
      let(:saved_scenario) { double('SavedScenario', title: 'Test', scenario_id: 10) }
      let(:scenario_users) { [{ 'user_id' => user.id, 'role_id' => 2 }] }

      before do
        allow(FetchSavedScenario).to receive(:call).and_return(
          ServiceResult.success(
            saved_scenario: saved_scenario,
            saved_scenario_users: scenario_users,
            private_flag: false
          )
        )
      end

      context 'with edit permissions' do
        before { get(:load, params: { id: 12, scenario_id: 10 }) }

        it { expect(response).to redirect_to play_path }

        it 'sets the active saved scenario id' do
          expect(session[:setting].active_saved_scenario_id).to eq(12)
        end

        it 'sets the api session id' do
          expect(session[:setting].api_session_id).to eq(ete_scenario_mock.id)
        end
      end

      context 'with view-only permissions' do
        let(:scenario_users) { [{ 'user_id' => user.id, 'role_id' => 1 }] }

        before { get(:load, params: { id: 12, scenario_id: 10 }) }

        it { expect(response).to redirect_to play_path }

        it 'does not set the active saved scenario id' do
          expect(session[:setting].active_saved_scenario_id).to be_nil
        end
      end

      context 'with no permissions on a private scenario' do
        let(:scenario_users) { [] }

        before do
          allow(FetchSavedScenario).to receive(:call).and_return(
            ServiceResult.success(
              saved_scenario: saved_scenario,
              saved_scenario_users: scenario_users,
              private_flag: true
            )
          )
          get(:load, params: { id: 12, scenario_id: 10 })
        end

        it 'redirects to play path with unauthorized message' do
          expect(response).to redirect_to play_path
          expect(flash[:alert]).to eq(I18n.t('scenario.unauthorized'))
        end
      end

      pending 'when authentication is required' do # TODO: Check flow here
        before do
          allow(controller).to receive(:signed_in?).and_return(false)
          session[:user_id] = nil
          get :load, params: { id: 12, scenario_id: 10, current_user: 'true' }
        end

        it 'redirects to sign in' do
          expect(response).to redirect_to(sign_in_path(show_as: :sign_in))
        end
      end

      context 'when the saved scenario fails to load' do
        before do
          allow(FetchSavedScenario).to receive(:call).and_return(
            ServiceResult.failure('Saved scenario not found')
          )
          get(:load, params: { id: 12, scenario_id: 10 })
        end

        it 'redirects to root with error message' do
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq(I18n.t('scenario.cannot_load'))
        end
      end

      context 'when the scenario is already active' do
        before do
          session[:setting].active_saved_scenario_id = 12
          session[:setting].api_session_id = 100_000
          get(:load, params: { id: 12, scenario_id: 10 })
        end

        it { expect(response).to redirect_to play_path }

        it 'does not update the scenario (session) id' do
          expect(session[:setting].api_session_id).to eq(100_000)
        end

        it 'updates the scenario title' do
          expect(session[:setting].active_scenario_title).to eq('Test')
        end
      end
    end
  end

  describe 'GET new' do
    before do
      session[:setting] = Setting.new
      session[:setting].api_session_id = 100_000
    end

    it 'renders the new saved scenario form' do
      sign_in(user)
      get :new

      expect(response).to be_ok
    end
  end

  describe 'POST create' do
    before do
      sign_in(user)
      session[:setting] = Setting.new

      allow(CreateAPIScenario).to receive(:call).and_return(
        ServiceResult.success(Engine::Scenario.new(
          attributes_for(:engine_scenario, id: 999, area_code: 'nl', end_year: 2050)
        ))
      )
      allow(CreateSavedScenario).to receive(:call).and_return(
        ServiceResult.success({ 'id' => 12 })
      )
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
        expect(session[:setting][:api_session_id]).to eq(999)
      end

      it 'redirect to the scenario' do
        expect(request).to redirect_to(play_path)
      end
    end

    context 'with invalid attributes' do
      let(:request) do
        post :create, params: {
          saved_scenario: { scenario_id: 1, title: "" }
        }
      end

      before do
        allow(CreateSavedScenario).to receive(:call).and_return(
          ServiceResult.failure('Title cannot be blank')
        )
      end

      it 'does not redirect' do
        expect(request).not_to redirect_to(play_path)
      end

      it 'does not create a new ApiScenario' do
        expect { request }.not_to(change { session[:setting][:api_session_id] })
      end

      it 'returns a meaningful error' do
        request
        expect(flash[:alert]).not_to be_nil
      end
    end
  end

  describe 'PUT update' do
    subject(:make_request) do
      put :update, format: :json, params: {
        id: 12,
        scenario_id: 1,
        title: 'Some new title'
      }
    end

    context 'when UpdateSavedScenario succeeds' do
      before do
        allow(UpdateSavedScenario).to receive(:call).and_return(
          ServiceResult.success(saved_scenario: scenario_mock)
        )
      end

      it 'returns a JSON response with the new api_session_id' do
        allow(CreateAPIScenario).to receive(:call).and_return(
          ServiceResult.success(scenario_mock)
        )

        make_request
        body = JSON.parse(response.body)

        expect(body['api_session_id']).to eq('123')
        expect(response).to be_successful
      end

      it 'does not change the scenario title if not handled in UpdateSavedScenario' do
        make_request
        expect(scenario_mock.title).to eq('title')
      end
    end

    context 'when UpdateSavedScenario fails' do
      before do
        allow(UpdateSavedScenario).to receive(:call).and_return(
          ServiceResult.failure('Some error')
        )
      end

      it 'does not call CreateAPIScenario and returns an error response' do
        expect(CreateAPIScenario).not_to receive(:call)

        make_request
        expect(response.status).to eq(422)
      end
    end
  end
end
