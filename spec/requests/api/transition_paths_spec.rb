# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::TransitionPaths', type: :request, api: true do
  let(:user) { create(:user) }

  pending 'GET /api/v1/transition_paths' do

    context 'with an access token with the correct scope' do
      let!(:user_path1) { create(:multi_year_chart, user:) }
      let!(:user_path2) { create(:multi_year_chart, user:) }
      let!(:other_path) { create(:multi_year_chart) }

      before do
        get '/api/v1/transition_paths',
          as: :json,
          headers: authorization_header(user, ['scenarios:read'])
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the transition paths' do
        expect(JSON.parse(response.body)['data']).to eq([
          user_path1.as_json,
          user_path2.as_json
        ])
      end

      it 'does not contain transition paths from other users' do
        expect(JSON.parse(response.body)['data']).not_to include(other_path.as_json)
      end
    end

    context 'with an access token with the correct scope, but the user does not exist' do
      let(:request) do
        get '/api/v1/transition_paths',
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
        get '/api/v1/transition_paths', as: :json
      end

      it 'returns success' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with an access token with the incorrect scope' do
      before do
        get '/api/v1/transition_paths',
          as: :json,
          headers: authorization_header(user, [])
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  # ------------------------------------------------------------------------------------------------

  pending 'GET /api/v1/transition_paths/:id' do
    pending "DESTROY"
    let(:transition_path) { create(:multi_year_chart, user:) }

    context 'with a valid access token' do
      before do
        get "/api/v1/transition_paths/#{transition_path.id}",
          as: :json,
          headers: authorization_header(user, 'scenarios:read')
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the transition path' do
        expect(JSON.parse(response.body)).to eq(transition_path.as_json)
      end
    end

    context 'without an access token' do
      before do
        get "/api/v1/transition_paths/#{transition_path.id}", as: :json
      end

      it 'returns success' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with an access token with the incorrect scope' do
      before do
        get "/api/v1/transition_paths/#{transition_path.id}",
          as: :json,
          headers: authorization_header(user, [])
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the transition path belongs to someone else' do
      let(:different_user) { create(:user) }

      before do
        get "/api/v1/transition_paths/#{transition_path.id}",
          as: :json,
          headers: authorization_header(different_user, 'scenarios:read')
      end

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # ------------------------------------------------------------------------------------------------

  pending 'POST /api/v1/transition_paths/:id' do
    pending "DESTROY"
    let(:request) do
      post '/api/v1/transition_paths',
        as: :json,
        params: path_attributes,
        headers:
    end

    let(:headers) do
      authorization_header(user, %w[scenarios:read scenarios:write])
    end

    let(:path_attributes) do
      {
        area_code: 'nl',
        end_year: 2050,
        scenario_ids: [1, 2, 3],
        title: 'My transition path'
      }
    end

    context 'when given a valid access token and data, and the user exists' do
      it 'returns created' do
        request
        expect(response).to have_http_status(:created)
      end

      it 'creates a transition path' do
        expect { request }.to change(user.multi_year_charts, :count).by(1)
      end

      it 'returns the transition path' do
        request
        expect(JSON.parse(response.body)).to eq(user.multi_year_charts.last.as_json)
      end

      it 'sets the scenario IDs' do
        request
        expect(JSON.parse(response.body)['scenario_ids']).to eq([1, 2, 3])
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

      it 'creates a transition path' do
        expect { request }.to change(user.multi_year_charts, :count).by(1)
      end

      it 'returns the transition path' do
        request
        expect(JSON.parse(response.body)).to eq(user.reload.multi_year_charts.last.as_json)
      end
    end

    context 'when given a valid access token and invalid data' do
      before { user.destroy! }

      let(:path_attributes) { super().except(:area_code) }

      it 'returns unprocessable entity' do
        request
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a transition path' do
        expect { request }.not_to change(user.multi_year_charts, :count)
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

      it 'does not create a transition path' do
        expect { request }.not_to change(user.multi_year_charts, :count)
      end
    end
  end

  # ------------------------------------------------------------------------------------------------

  pending 'PUT /api/v1/transition_paths/:id' do
    let(:path) do
      create(
        :multi_year_chart,
        area_code: 'nl',
        end_year: 2050,
        title: 'My transition path',
        user:
      )
    end

    let(:request) do
      put "/api/v1/transition_paths/#{path.id}",
        as: :json,
        params: path_attributes,
        headers: authorization_header(user, %w[scenarios:read scenarios:write])
    end

    let(:path_attributes) do
      {
        area_code: 'uk',
        end_year: 2060,
        title: 'My updated transition path',
        scenario_ids: [1000, 2000]
      }
    end

    context 'when given a valid access token and data' do
      it 'returns success' do
        request
        expect(response).to have_http_status(:success)
      end

      it 'updates the transition path' do
        keys = path_attributes.keys - [:scenario_ids]

        expect { request }
          .to change { path.reload.attributes.symbolize_keys.slice(*keys) }
          .from(area_code: 'nl', end_year: 2050, title: 'My transition path')
          .to(path_attributes.except(:scenario_ids))
      end

      it 'changes the scenario IDs' do
        request
        expect(JSON.parse(response.body)['scenario_ids']).to eq([1000, 2000])
      end
    end

    context 'when updating without scenario IDs' do
      let(:path_attributes) { super().except(:scenario_ids) }

      it 'returns success' do
        request
        expect(response).to have_http_status(:success)
      end

      it 'does not change the scenario IDs' do
        ids = path.scenarios.pluck(:scenario_id).sort

        request
        expect(JSON.parse(response.body)['scenario_ids']).to eq(ids)
      end
    end

    context 'when given invalid data' do
      let(:path_attributes) do
        super().merge(title: '')
      end

      it 'returns unprocessable entity' do
        request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the transition path belongs to a different user' do
      let(:request) do
        put "/api/v1/transition_paths/#{path.id}",
          as: :json,
          params: path_attributes,
          headers: authorization_header(create(:user), %w[scenarios:read scenarios:write])
      end

      it 'returns not found' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # ------------------------------------------------------------------------------------------------

  pending 'DELETE /api/v1/transition_paths/:id' do
    let!(:path) { create(:multi_year_chart, user:) }

    context 'when the transition path belongs to the user' do
      let(:request) do
        delete "/api/v1/transition_paths/#{path.id}",
          as: :json,
          headers: authorization_header(user, %w[scenarios:read scenarios:delete])
      end

      it 'returns success' do
        request
        expect(response).to have_http_status(:success)
      end

      it 'removes the transition path' do
        expect { request }.to change(user.multi_year_charts, :count).by(-1)
      end
    end

    context 'when missing the scenarios:delete scope' do
      let(:request) do
        delete "/api/v1/transition_paths/#{path.id}",
          as: :json,
          headers: authorization_header(user, %w[scenarios:read scenarios:write])
      end

      it 'returns forbidden' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the transition path belongs to a different user' do
      let(:request) do
        delete "/api/v1/transition_paths/#{path.id}",
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
