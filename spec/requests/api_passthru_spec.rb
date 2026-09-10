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
          'access-control-allow-origin' => 'http://www.example.com',
          'access-control-allow-methods' => 'GET',
          'access-control-allow-headers' => 'Accept, Content-Type',
          'vary' => 'Origin'
        )
      end
    end

    context 'when authenticated via the shared session cookie' do
      let(:user) { create(:user) }
      let(:claims) do
        {
          'sub' => user.id,
          'exp' => 1.hour.from_now.to_i,
          'user' => { 'id' => user.id, 'name' => user.name, 'email' => user.email, 'admin' => false }
        }
      end

      before { allow(Identity::TokenDecoder).to receive(:decode).and_return(claims) }

      it 'redirects carrying the cookie JWT as the access token' do
        get('/passthru/123/abc', headers: { 'Cookie' => 'etm_session=raw.jwt' })

        expect(response).to redirect_to(
          "#{Settings.ete_url}/api/v3/scenarios/123/abc?access_token=raw.jwt"
        )
      end
    end
  end
end
