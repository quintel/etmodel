require 'rails_helper'

RSpec.describe 'API::User', type: :request, api: true do
  describe 'PUT /api/v1/user' do
    let(:user) { FactoryBot.create(:user) }

    context 'given a valid token and body' do
      before do
        put '/api/v1/user',
          as: :json,
          params: { id: user.id, name: 'John' },
          headers: { 'Authorization' => "Bearer #{generate_jwt(user)}" }
      end

      it 'returns 200 OK' do
        expect(response).to be_successful
      end

      it 'updates the user' do
        expect(JSON.parse(response.body)).to include('id' => user.id, 'name' => 'John')
      end
    end

    context 'given an invalid user' do
      before do
        put '/api/v1/user',
          as: :json,
          params: { id: user.id, name: ' ' },
          headers: { 'Authorization' => "Bearer #{generate_jwt(user)}" }
      end

      it 'returns 400 Bad Request' do
        expect(response.status).to eq(400)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)['errors'])
          .to eq(['param is missing or the value is empty: name'])
      end
    end

    context 'given a non-matching token and user' do
      before do
        put '/api/v1/user',
          as: :json,
          params: { id: user.id + 1, name: 'John' },
          headers: { 'Authorization' => "Bearer #{generate_jwt(user)}" }
      end

      it 'returns 403 Forbidden' do
        expect(response.status).to eq(403)
      end
    end
  end
end
