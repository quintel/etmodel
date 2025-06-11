# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'APIPassthru', type: :request do
  describe 'GET /passthru/123/abc' do
    context 'when as a guest' do
      it 'redirects to the Engine /api/v3/scenarios/123/abc endpoint' do
        expect(get('/passthru/123/abc')).to redirect_to(
          "#{Settings.ete_url}/api/v3/scenarios/123/abc"
        )
      end

      it 'sets CORS headers' do
        get('/passthru/123/abc')

        expect(response.headers.to_h).to include(
          'Access-Control-Allow-Origin' => 'http://www.example.com',
          'Access-Control-Allow-Methods' => 'GET',
          'Access-Control-Allow-Headers' => 'Accept, Content-Type',
          'Vary' => 'Origin'
        )
      end
    end

    context 'when signed in' do
      it 'redirects to the Engine /api/v3/scenarios/123/abc endpoint with an access token' do
        user = create(:user)
        token = sign_in(user)

        expect(get('/passthru/123/abc')).to redirect_to(
          "#{Settings.ete_url}/api/v3/scenarios/123/abc?access_token=#{token.token}"
        )
      end
    end
  end
end
