# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Content pages', type: :request do
  describe 'GET /development' do
    context 'English version' do
      it 'renders successfully' do
        VCR.use_cassette('content_pages/development_en') do
          get '/development', params: { locale: :en }
          follow_redirect! if response.redirect?

          expect(response).to have_http_status(:ok)
        end
      end

      it 'contains correct contact links' do
        VCR.use_cassette('content_pages/development_en') do
          get '/development', params: { locale: :en }
          follow_redirect! if response.redirect?

          expect(response.body).to include('https://my.energytransitionmodel.com/contact')
        end
      end

      it 'contains the "Contact us" link text' do
        VCR.use_cassette('content_pages/development_en') do
          get '/development', params: { locale: :en }
          follow_redirect! if response.redirect?

          expect(response.body).to include('Contact us')
        end
      end
    end

    context 'Dutch version' do
      it 'renders successfully' do
        VCR.use_cassette('content_pages/development_nl') do
          get '/development', params: { locale: :nl }
          follow_redirect! if response.redirect?

          expect(response).to have_http_status(:ok)
        end
      end

      it 'contains correct contact link' do
        VCR.use_cassette('content_pages/development_nl') do
          get '/development', params: { locale: :nl }
          follow_redirect! if response.redirect?

          expect(response.body).to include('https://my.energytransitionmodel.com/contact')
        end
      end
    end
  end
end
