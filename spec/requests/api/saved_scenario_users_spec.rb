# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::SavedScenarioUsers', type: :request, api: true do
  let(:user) { create(:user) }
  let!(:saved_scenario) { create(:saved_scenario, user: user) }

  # Stub all APIScenarioUser generation
  before do
    allow_any_instance_of(CreateAPIScenarioUser).to receive(:call).and_return(true)
    allow_any_instance_of(UpdateAPIScenarioUser).to receive(:call).and_return(true)
    allow_any_instance_of(DestroyAPIScenarioUser).to receive(:call).and_return(true)
  end

  describe 'GET index' do
    it 'returns invalid token without a proper access token' do
      get "/api/v1/saved_scenarios/#{saved_scenario.id}/users", as: :json

      expect(response.status).to be(401)
    end

    # A user should have a token with the scenario:delete scope before its allowed
    # to do anything through this endpoint, because this is what equals to the 'owner' role.
    it 'returns forbidden for a token without the proper access scope' do
      get "/api/v1/saved_scenarios/#{saved_scenario.id}/users", as: :json,
        headers: authorization_header(user, ['scenarios:read'])

      expect(response).to have_http_status(:forbidden)
    end

    context 'with a proper token and scope' do
      before do
        get "/api/v1/saved_scenarios/#{saved_scenario.id}/users", as: :json,
          headers: authorization_header(user, ['scenarios:delete'])

      end

      it 'returns success' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a list of all users' do
        expect(JSON.parse(response.body)).to include(
          a_hash_including('user_id' => user.id, 'user_email' => nil, 'role' => 'scenario_owner')
        )
      end
    end
  end

  describe 'POST /api/v1/saved_scenarios/:id/users' do
    context 'with proper params' do
      before do
        post "/api/v1/saved_scenarios/#{saved_scenario.id}/users", as: :json,
          headers: authorization_header(user, ['scenarios:delete']),
          params: {
            saved_scenario_users: [
              { user_email: 'viewer@test.com', role: 'scenario_viewer' },
              { user_email: 'collaborator@test.com', role: 'scenario_collaborator' },
              { user_email: 'owner@test.com', role: 'scenario_owner' }
            ]
          }
      end

      it 'returns success' do
        pp response.body

        expect(response).to have_http_status(:created)
      end

      it 'adds the given users to the scenario' do
        expect(JSON.parse(response.body)).to include(
          a_hash_including('user_id' => nil, 'user_email' => 'viewer@test.com', 'role' => 'scenario_viewer'),
          a_hash_including('user_id' => nil, 'user_email' => 'collaborator@test.com', 'role' => 'scenario_collaborator'),
          a_hash_including('user_id' => nil, 'user_email' => 'owner@test.com', 'role' => 'scenario_owner')
        )
      end
    end

    context 'with malformed user params' do
      before do
        post "/api/v1/saved_scenarios/#{saved_scenario.id}/users", as: :json,
          headers: authorization_header(user, ['scenarios:delete']),
          params: {
            saved_scenario_users: [{ user_email: 'viewer@test.com' }]
          }
      end

      it 'returns 422: unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error' do
        expect(response.body).to eq(
          { user_email: 'viewer@test.com', error: 'role_id is invalid.' }.to_json
        )
      end
    end

    context 'with duplicate user params' do
      before do
        post "/api/v1/saved_scenarios/#{saved_scenario.id}/users", as: :json,
          headers: authorization_header(user, ['scenarios:delete']),
          params: {
            saved_scenario_users: [
              { user_email: 'viewer@test.com', role: 'scenario_viewer' },
              { user_email: 'viewer@test.com', role: 'scenario_collaborator' },
            ]
          }
      end

      it 'returns 422: unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error' do
        expect(response.body).to eq(
          {
            role: 'scenario_collaborator', user_email: 'viewer@test.com',
            error: 'A user with this ID or email already exists for this saved scenario'
          }.to_json
        )
      end
    end
  end

  describe 'PUT /api/v1/saved_scenarios/:id/users' do
    context 'with proper params' do
      let(:user_2) { create(:user) }
      let(:user_3) { create(:user) }

      before do
        create(:saved_scenario_user,
          saved_scenario: saved_scenario, user: user_2,
          role_id: User::ROLES.key(:scenario_viewer)
        )
        create(:saved_scenario_user,
          saved_scenario: saved_scenario, user: user_3,
          role_id: User::ROLES.key(:scenario_collaborator)
        )

        put "/api/v1/saved_scenarios/#{saved_scenario.id}/users", as: :json,
          headers: authorization_header(user, ['scenarios:delete']),
          params: {
            saved_scenario_users: [
              { user_id: user_2.id, role: 'scenario_owner' },
              { user_id: user_3.id, role: 'scenario_viewer' },
            ]
          }
      end

      it 'returns success' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates the role for the given user' do
        expect(JSON.parse(response.body)).to include(
          a_hash_including('user_id' => user_2.id, 'user_email' => nil, 'role' => 'scenario_owner'),
          a_hash_including('user_id' => user_3.id, 'user_email' => nil, 'role' => 'scenario_viewer')
        )
      end
    end

    context 'with a non-existing user id' do
      before do
        put "/api/v1/saved_scenarios/#{saved_scenario.id}/users", as: :json,
          headers: authorization_header(user, ['scenarios:delete']),
          params: {
            saved_scenario_users: [
              { user_id: 999, role: 'scenario_collaborator' },
            ]
          }
      end

      it 'returns 404: not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error' do
        expect(response.body).to eq(
          { 'role' => 'scenario_collaborator', 'user_id' => 999, 'error' => 'Saved scenario user not found' }.to_json
        )
      end
    end

    context 'with a missing role' do
      before do
        put "/api/v1/saved_scenarios/#{saved_scenario.id}/users", as: :json,
          headers: authorization_header(user, ['scenarios:delete']),
          params: {
            saved_scenario_users: [{ user_id: 999 }]
          }
      end

      it 'returns 422: unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error' do
        expect(response.body).to eq(
          { user_id: 999, error: 'Missing attribute(s) for saved scenario user: role' }.to_json
        )
      end
    end
  end

  describe 'DELETE /api/v1/saved_scenarios/:id/users' do
    context 'with proper params' do
      let(:user_2) { create(:user) }
      let(:user_3) { create(:user) }

      before do
        create(:saved_scenario_user,
          saved_scenario: saved_scenario, user: user_2,
          role_id: User::ROLES.key(:scenario_viewer)
        )
        create(:saved_scenario_user,
          saved_scenario: saved_scenario, user: user_3,
          role_id: User::ROLES.key(:scenario_collaborator)
        )

        delete "/api/v1/saved_scenarios/#{saved_scenario.id}/users", as: :json,
          headers: authorization_header(user, ['scenarios:delete']),
          params: {
            saved_scenario_users: [{ user_id: user_2.id }, { user_id: user_3.id }]
          }
      end

      it 'returns OK' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty response body' do
        expect(response.body).to eq('')
      end

      it 'removes the given users' do
        expect(
          saved_scenario.saved_scenario_users.count
        ).to be(1)
      end
    end

    context 'with a non-existing user id' do
      before do
        delete "/api/v1/saved_scenarios/#{saved_scenario.id}/users", as: :json,
          headers: authorization_header(user, ['scenarios:delete']),
          params: {
            saved_scenario_users: [{ user_id: 999 }]
          }
      end

      it 'returns OK' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty response body' do
        expect(response.body).to eq('')
      end
    end
  end
end
