# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Region pages', type: :request do
  before do
    allow(Engine::Area).to receive(:find_by_country_memoized).and_return(build(:api_area))
    allow(MyEtm::Version).to receive(:listed).and_return([ MyEtm::Version.new(tag: 'latest') ])
  end

  def factsheet
    response.parsed_body.at_css('#establishment_shot')
  end

  describe 'GET /regions/:dataset_locale' do
    it 'passes a numeric scenario ID to the page' do
      get '/regions/nl', params: { scenario: '123' }

      expect(factsheet['data-scenario-id']).to eq('123')
    end

    it 'links the year toggle to a numeric scenario ID' do
      get '/regions/nl', params: { scenario: '123' }

      expect(response.parsed_body.css('.toggle_year a').map { |a| a['href'] })
        .to all(include('scenario=123'))
    end

    [ '123?private=true', '../123', '123/456', '123abc', ' 123', '' ].each do |value|
      it "ignores the scenario parameter #{value.inspect}" do
        get '/regions/nl', params: { scenario: value }

        expect(factsheet['data-scenario-id']).to be_nil
        expect(response.parsed_body.css('.toggle_year')).to be_empty
      end
    end

    it 'does not put the access token in the page' do
      token = sign_in(create(:user))

      get '/regions/nl'

      expect(factsheet['data-access-token']).to be_nil
      expect(response.body).not_to include(token)
    end
  end
end
