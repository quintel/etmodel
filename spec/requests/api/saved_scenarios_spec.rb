# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::SavedScenarios', type: :request, api: true do
  let(:user) { create(:user) }

  describe 'GET /api/v1/saved_scenarios' do
    context 'with an access token with the correct scope' do
      let!(:user_ss1) { create(:saved_scenario, user:) }
      let!(:user_ss2) { create(:saved_scenario, user:) }
      let!(:other_ss) { create(:saved_scenario) }

      before do
        get '/api/v1/saved_scenarios',
          as: :json,
          headers: authorization_header(user, ['scenarios:read'])
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the saved scenarios' do
        expect(response.parsed_body['data']).to eq([
          user_ss1.as_json,
          user_ss2.as_json
        ])
      end

      it 'does not contain scenarios from other users' do
        expect(JSON.parse(response.body)['data']).not_to include(other_ss.as_json)
      end
    end

    context 'with an access token with the correct scope, but the user does not exist' do
      let(:request) do
        get '/api/v1/saved_scenarios',
          as: :json,
          headers: authorization_header(user, 'scenarios:read')
      end

      before { user.destroy! }

      it 'creates the user from the access token' do
        expect { request }.to change(User, :count).by(1)
      end

      it 'returns success' do
        request
        expect(response).to have_http_status(:success)
      end
    end

    context 'without an access token' do
      before do
        get '/api/v1/saved_scenarios', as: :json
      end

      it 'returns success' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with an access token with the incorrect scope' do
      before do
        get '/api/v1/saved_scenarios',
          as: :json,
          headers: authorization_header(user, [])
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  # ------------------------------------------------------------------------------------------------

  describe 'GET /api/v1/saved_scenarios/:id' do
    let(:saved_scenario) { create(:saved_scenario, user:) }

    context 'with a valid access token' do
      before do
        get "/api/v1/saved_scenarios/#{saved_scenario.id}",
          as: :json,
          headers: authorization_header(user, 'scenarios:read')
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the saved scenario' do
        expect(JSON.parse(response.body)).to eq(saved_scenario.as_json)
      end
    end

    context 'without an access token' do
      before do
        get '/api/v1/saved_scenarios/1', as: :json
      end

      it 'returns success' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with an access token with the incorrect scope' do
      before do
        get "/api/v1/saved_scenarios/#{saved_scenario.id}",
          as: :json,
          headers: authorization_header(user, [])
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the scenario belongs to someone else' do
      let(:different_user) { create(:user) }

      before do
        get "/api/v1/saved_scenarios/#{saved_scenario.id}",
          as: :json,
          headers: authorization_header(different_user, 'scenarios:read')
      end

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # ------------------------------------------------------------------------------------------------

  describe 'POST /api/v1/saved_scenarios/:id' do
    let(:request) do
      post '/api/v1/saved_scenarios',
        as: :json,
        params: scenario_attributes,
        headers:
    end

    let(:headers) do
      authorization_header(user, %w[scenarios:read scenarios:write])
    end

    let(:scenario_attributes) do
      {
        area_code: 'nl',
        end_year: 2050,
        scenario_id: 1,
        title: 'My scenario'
      }
    end

    context 'when given a valid access token and data, and the user exists' do
      it 'returns created' do
        request
        expect(response).to have_http_status(:created)
      end

      it 'creates a saved scenario' do
        expect { request }.to change(user.saved_scenarios, :count).by(1)
      end

      it 'returns the scenario' do
        request
        expect(JSON.parse(response.body)).to eq(user.saved_scenarios.last.as_json)
      end
    end

    context 'when given a valid access token and data, but the user does not exist' do
      before { user.destroy! }

      it 'returns created' do
        request
        expect(response).to have_http_status(:created)
      end

      it 'creates the user' do
        expect { request }.to change(User, :count).by(1)
      end

      it 'creates a saved scenario' do
        expect { request }.to change(user.saved_scenarios, :count).by(1)
      end

      it 'returns the scenario' do
        request
        expect(JSON.parse(response.body)).to eq(user.reload.saved_scenarios.last.as_json)
      end
    end

    context 'when given a valid access token and invalid data' do
      before { user.destroy! }

      let(:scenario_attributes) { super().except(:area_code) }

      it 'returns unprocessable entity' do
        request
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a saved scenario' do
        expect { request }.not_to change(user.saved_scenarios, :count)
      end
    end

    context 'when given a token without the scenarios:write scope' do
      before { user.destroy! }

      let(:headers) do
        authorization_header(user, 'scenarios:read')
      end

      it 'returns forbidden' do
        request
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not create a saved scenario' do
        expect { request }.not_to change(user.saved_scenarios, :count)
      end
    end
  end

  # ------------------------------------------------------------------------------------------------

  describe 'PUT /api/v1/saved_scenarios/:id' do
    let(:scenario) do
      create(
        :saved_scenario,
        area_code: 'nl',
        end_year: 2050,
        scenario_id: 1,
        title: 'My scenario',
        user:
      )
    end

    let(:request) do
      put "/api/v1/saved_scenarios/#{scenario.id}",
        as: :json,
        params: scenario_attributes,
        headers: authorization_header(user, %w[scenarios:read scenarios:write])
    end

    let(:scenario_attributes) do
      {
        area_code: 'uk',
        end_year: 2060,
        scenario_id: 2,
        title: 'My updated scenario'
      }
    end

    context 'when given a valid access token and data' do
      it 'returns success' do
        request
        expect(response).to have_http_status(:success)
      end

      it 'updates the saved scenario' do
        expect { request }
          .to change { scenario.reload.attributes.symbolize_keys.slice(*scenario_attributes.keys) }
          .from(area_code: 'nl', end_year: 2050, scenario_id: 1, title: 'My scenario')
          .to(scenario_attributes)
      end

      it 'adds the previous scenario ID to the history' do
        previous_id = scenario.scenario_id

        expect { request }
          .to change { scenario.reload.scenario_id_history }
          .from([])
          .to([previous_id])
      end
    end

    context 'when updating without a scenario ID' do
      let(:scenario_attributes) { super().except(:scenario_id) }

      it 'returns success' do
        request
        expect(response).to have_http_status(:success)
      end

      it 'does not change the scenario ID history' do
        expect { request }
          .not_to change { scenario.reload.scenario_id_history }
          .from([])
      end

      it 'does not change the scenario ID' do
        expect { request }.not_to change { scenario.reload.scenario_id }
      end
    end

    context 'when updating with the same scenario ID' do
      let(:scenario_attributes) { super().merge(scenario_id: scenario.scenario_id) }

      it 'returns success' do
        request
        expect(response).to have_http_status(:success)
      end

      it 'does not change the scenario ID history' do
        expect { request }
          .not_to change { scenario.reload.scenario_id_history }
          .from([])
      end
    end

    context 'when updating with a historic scenario ID' do
      before do
        scenario.update(scenario_id_history: [999_999, 2, 111_111])
        scenario.reload
      end

      it 'returns success' do
        request
        expect(response).to have_http_status(:success)
      end

      it 'changes the scenario ID history' do
        expect { request }
          .to change { scenario.reload.scenario_id_history }
          .from([999_999, 2, 111_111]).to([999_999])
      end

      it 'changes the scenario ID' do
        expect { request }.to change { scenario.reload.scenario_id }.from(1).to(2)
      end
    end

    context 'when given invalid data' do
      let(:scenario_attributes) do
        super().merge(title: '')
      end

      it 'returns unprocessable entity' do
        request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the scenario belongs to a different user' do
      let(:request) do
        put "/api/v1/saved_scenarios/#{scenario.id}",
          as: :json,
          params: scenario_attributes,
          headers: authorization_header(create(:user), %w[scenarios:read scenarios:write])
      end

      it 'returns not found' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when discarding a scenario' do
      let(:request) do
        put "/api/v1/saved_scenarios/#{scenario.id}",
          as: :json,
          params: scenario_attributes.merge(discarded: true),
          headers: authorization_header(user, %w[scenarios:read scenarios:write])
      end

      it 'is successful' do
        request
        expect(response).to have_http_status(:ok)
      end

      it 'sets the discarded_at timestamp' do
        expect { request }.to change { scenario.reload.discarded_at }.from(nil)
      end
    end

    context 'when discarding an already discarded scenario' do
      let(:request) do
        put "/api/v1/saved_scenarios/#{scenario.id}",
          as: :json,
          params: scenario_attributes.merge(discarded: true),
          headers: authorization_header(user, %w[scenarios:read scenarios:write])
      end

      before do
        scenario.update(discarded_at: 1.day.ago)
      end

      it 'sets the discarded_at timestamp' do
        expect { request }.not_to change { scenario.reload.discarded_at }
          .from(scenario.discarded_at)
      end
    end

    context 'when undiscarding a scenario' do
      let(:request) do
        put "/api/v1/saved_scenarios/#{scenario.id}",
          as: :json,
          params: scenario_attributes.merge(discarded: false),
          headers: authorization_header(user, %w[scenarios:read scenarios:write])
      end

      before do
        scenario.update(discarded_at: 1.day.ago)
      end

      it 'sets the discarded_at timestamp' do
        expect { request }.to change { scenario.reload.discarded_at }
          .from(scenario.discarded_at)
          .to(nil)
      end
    end

    context 'when undiscarding a non-discarded scenario' do
      let(:request) do
        put "/api/v1/saved_scenarios/#{scenario.id}",
          as: :json,
          params: scenario_attributes.merge(discarded: false),
          headers: authorization_header(user, %w[scenarios:read scenarios:write])
      end

      it 'sets the discarded_at timestamp' do
        expect { request }.not_to change { scenario.reload.discarded_at }.from(nil)
      end
    end
  end

  # ------------------------------------------------------------------------------------------------

  describe 'DELETE /api/v1/saved_scenarios/:id' do
    let!(:scenario) { create(:saved_scenario, user:) }

    context 'when the scenario belongs to the user' do
      let(:request) do
        delete "/api/v1/saved_scenarios/#{scenario.id}",
          as: :json,
          headers: authorization_header(user, %w[scenarios:read scenarios:delete])
      end

      it 'returns success' do
        request
        expect(response).to have_http_status(:success)
      end

      it 'removes the scenario' do
        expect { request }.to change(user.saved_scenarios, :count).by(-1)
      end
    end

    context 'when missing the scenarios:delete scope' do
      let(:request) do
        delete "/api/v1/saved_scenarios/#{scenario.id}",
          as: :json,
          headers: authorization_header(user, %w[scenarios:read scenarios:write])
      end

      it 'returns forbidden' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the scenario belongs to a different user' do
      let(:request) do
        delete "/api/v1/saved_scenarios/#{scenario.id}",
          as: :json,
          headers: authorization_header(create(:user), %w[scenarios:read scenarios:delete])
      end

      it 'returns not found' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
