# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::SavedScenarioVersions', type: :request, api: true do
  let(:user) { create(:user) }
  let!(:saved_scenario) { create(:saved_scenario, user: user) }
  let!(:first_saved_scenario_version) { create(:saved_scenario_version, saved_scenario: saved_scenario, scenario_id: 123) }
  let!(:current_saved_scenario_version) { create(:saved_scenario_version, saved_scenario: saved_scenario, scenario_id: 234) }

  describe 'GET index' do
    it 'returns invalid token without a proper access token' do
      get "/api/v1/saved_scenarios/#{saved_scenario.id}/versions", as: :json

      expect(response.status).to be(401)
    end

    # A user should have a token with the scenario:delete scope before its allowed
    # to do anything through this endpoint, because this is what equals to the 'owner' role.
    it 'returns forbidden for a token without the proper access scope' do
      get "/api/v1/saved_scenarios/#{saved_scenario.id}/versions", as: :json,
        headers: authorization_header(user, ['scenarios:read'])

      expect(response).to have_http_status(:forbidden)
    end

    context 'with a proper token and scope' do
      before do
        get "/api/v1/saved_scenarios/#{saved_scenario.id}/versions", as: :json,
          headers: authorization_header(user, ['scenarios:write'])
      end

      it 'returns success' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a list of all versions' do
        expect(response.parsed_body['data']).to eq([
          first_saved_scenario_version.as_json,
          current_saved_scenario_version.as_json
        ])
      end
    end
  end

  describe 'GET /api/v1/saved_scenarios/:id/versions/:id' do
    let(:saved_scenario) { create(:saved_scenario, user:) }

    context 'when the version is existing and self-owned' do
      before do
        get "/api/v1/saved_scenarios/#{saved_scenario.id}/versions/#{current_saved_scenario_version.id}",
          as: :json, headers: authorization_header(user, ['scenarios:write'])
      end

      it 'returns success' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the requested version' do
        expect(response.parsed_body).to eq(current_saved_scenario_version.as_json)
      end
    end

    context 'when the version is non-existing' do
      before do
        get "/api/v1/saved_scenarios/#{saved_scenario.id}/versions/999",
          as: :json, headers: authorization_header(user, ['scenarios:write'])
      end

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the scenario belongs to someone else' do
      let(:different_user) { create(:user) }

      before do
        get "/api/v1/saved_scenarios/#{saved_scenario.id}/versions/#{current_saved_scenario_version.id}",
          as: :json, headers: authorization_header(different_user, ['scenarios:write'])
      end

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/saved_scenarios/:id/versions' do
    context 'with proper params' do
      before do
        post "/api/v1/saved_scenarios/#{saved_scenario.id}/versions",
          as: :json,
          headers: authorization_header(user, ['scenarios:write']),
          params: {
            saved_scenario_id: saved_scenario,
            scenario_id: 999,
            message: 'New version!'
          }
      end

      it 'returns success' do
        expect(response).to have_http_status(:created)
      end

      it 'adds the given version to the saved scenario' do
        expect(response.body).to eq(saved_scenario.saved_scenario_versions.last.to_json)
      end
    end

    context 'with malformed version params' do
      before do
        post "/api/v1/saved_scenarios/#{saved_scenario.id}/versions",
          as: :json,
          headers: authorization_header(user, ['scenarios:write']),
          params: {
            saved_scenario_id: saved_scenario,
            scenario_id: 999
          }
      end

      it 'returns 422: unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error' do
        expect(response.body).to eq(
          { message: ["can't be blank"] }.to_json
        )
      end
    end
  end

  describe 'PUT /api/v1/saved_scenarios/:id/versions/:id' do
    context 'with proper params' do
      before do
        put "/api/v1/saved_scenarios/#{saved_scenario.id}/versions/#{current_saved_scenario_version.id}",
          as: :json,
          headers: authorization_header(user, ['scenarios:write']),
          params: { message: 'New version description!' }
      end

      it 'returns success' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates the version message' do
        expect(response.parsed_body).to include("message" => 'New version description!')
      end
    end

    context 'with extra params' do
      before do
        put "/api/v1/saved_scenarios/#{saved_scenario.id}/versions/#{current_saved_scenario_version.id}",
          as: :json,
          headers: authorization_header(user, ['scenarios:write']),
          params: { message: 'New version description!', scenario_id: 999 }
      end

      it 'returns success' do
        expect(response).to have_http_status(:ok)
      end

      it 'only updates the message and ignores the rest' do
        expect(response.parsed_body).to include(
          "message" => 'New version description!',
          "scenario_id" => 234
        )
      end
    end
  end

  describe 'GET /api/v1/saved_scenarios/:id/versions/:id/revert' do
    before do
      saved_scenario.update(saved_scenario_version_id: current_saved_scenario_version.id)
    end

    context 'when calling for an existing version' do
      before do
        get "/api/v1/saved_scenarios/#{saved_scenario.id}/versions/#{first_saved_scenario_version.id}/revert",
          as: :json, headers: authorization_header(user, ['scenarios:write'])
      end

      it 'returns success' do
        expect(response).to have_http_status(:ok)
      end

      it 'sets the given saved scenario version as the current version' do
        expect(saved_scenario.reload.current_version).to eq(first_saved_scenario_version)
      end

      it 'removes all future scenario versions' do
        expect(saved_scenario.reload.saved_scenario_versions.count).to eq(1)
      end
    end

    context 'when calling for a non-existing version' do
      before do
        get "/api/v1/saved_scenarios/#{saved_scenario.id}/versions/999/revert",
          as: :json, headers: authorization_header(user, ['scenarios:write'])
      end

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'does not change the current version' do
        expect(saved_scenario.reload.current_version).to eq(current_saved_scenario_version)
      end

      it 'does not removes any versions' do
        expect(saved_scenario.reload.saved_scenario_versions.count).to eq(2)
      end
    end
  end

end
