require 'rails_helper'

RSpec.describe 'API::User', type: :request, api: true do
  describe 'PUT /api/v1/user' do
    let(:user) { create(:user) }

    context 'when given a valid token and body' do
      before do
        put '/api/v1/user',
          as: :json,
          params: { id: user.id, name: 'John' },
          headers: authorization_header(user)
      end

      it 'returns 200 OK' do
        expect(response).to be_successful
      end

      it 'updates the user' do
        expect(JSON.parse(response.body)).to include('id' => user.id, 'name' => 'John')
      end
    end

    context 'when given an invalid user' do
      before do
        put '/api/v1/user',
          as: :json,
          params: { id: user.id, name: ' ' },
          headers: authorization_header(user)
      end

      it 'returns 400 Bad Request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)['errors'])
          .to eq(['param is missing or the value is empty: name'])
      end
    end

    context 'when given a non-matching token and user' do
      before do
        put '/api/v1/user',
          as: :json,
          params: { id: user.id + 1, name: 'John' },
          headers: authorization_header(user)
      end

      it 'returns 403 Forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
