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
