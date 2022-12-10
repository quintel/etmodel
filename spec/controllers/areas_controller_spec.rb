# frozen_string_literal: true

require 'rails_helper'

describe AreasController do
  describe 'on GET index' do
    before do
      allow(Engine::Area).to receive(:all).and_return([
        FactoryBot.build(:api_area, area: 'nl', area_code: 'nl'),
        FactoryBot.build(:api_area, area: 'be', area_code: 'be')
      ])
    end

    let(:response) { get(:index) }

    it { expect(response).to be_successful }
    it { expect(response.content_type).to start_with('application/json') }

    describe 'the response body' do
      let(:json) { JSON.parse(response.body) }

      it 'is an array of areas' do
        expect(json).to be_an(Array)
      end

      it 'includes all areas' do
        expect(json.length).to eq(2)
      end

      it 'has the area code' do
        expect(json[0]['id']).to eq('nl')
      end

      it 'has the translated area names' do
        expect(json[0]['name']).to eq(
          'en' => 'Netherlands',
          'nl' => 'Nederland'
        )
      end

      it 'has the icon information' do
        expect(json[0]['icon']).to include('height' => 17, 'width' => 23)
      end
    end
  end

  describe 'on GET show' do
    let(:response) { get(:show, params: { id: 'nl' }) }
    let(:json) { JSON.parse(response.body) }

    before do
      allow(Engine::Area).to receive(:find_by_country_memoized).with('nl').and_return(area)
    end

    context 'when the area has a flag' do
      let(:area) { FactoryBot.build(:api_area, area: 'nl', area_code: 'nl') }

      it 'has the area code' do
        expect(json['id']).to eq('nl')
      end

      it 'has the translated area names' do
        expect(json['name']).to eq(
          'en' => 'Netherlands',
          'nl' => 'Nederland'
        )
      end

      it 'has the icon information' do
        expect(json['icon']).to include('height' => 17, 'width' => 23)
      end
    end

    context 'when the area has no flag' do
      let(:area) { FactoryBot.build(:api_area, area: 'invalid', area_code: 'invalid') }

      it 'has the area code' do
        expect(json['id']).to eq('invalid')
      end

      it 'has the translated area names' do
        expect(json['name']).to eq(
          'en' => 'invalid',
          'nl' => 'invalid'
        )
      end

      it 'has no icon information' do
        expect(json['icon']).to be_nil
      end
    end

    context 'when the area does not exist' do
      let(:area) { nil }

      it 'returns a 404' do
        expect(response).to be_not_found
      end

      it 'returns useful error information' do
        expect(json).to eq('errors' => ['Area not found'])
      end
    end
  end
end
