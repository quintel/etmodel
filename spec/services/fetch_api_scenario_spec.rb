# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchAPIScenario do
  let(:result) { described_class.call(client, 123) }

  let(:response_data) do
    {
      'id' => 123,
      'area_code' => 'nl',
      'balanced_values' => { 'b' => 2 },
      'end_year' => 2050,
      'keep_compatible' => false,
      'metadata' => { 'title' => 'Hello' },
      'private' => false,
      'user_values' => { 'a' => 1 },
      'esdl_exportable' => false,
      'coupling' => false,
      'owner' => nil,
      'scaling' => nil,
      'template' => nil,
      'url' => 'http://example.com/scenarios/123',
      'created_at' => '2019-01-01T00:00:00.000Z',
      'updated_at' => '2019-01-01T00:00:00.000Z'
    }
  end

  context 'when the response contains data for the scenario' do
    let(:client) do
      Faraday.new do |builder|
        builder.adapter(:test) do |stub|
          stub.get('/api/v3/scenarios/123') do
            [
              200,
              { 'Content-Type' => 'application/json' },
              response_data
            ]
          end
        end
      end
    end

    it 'returns a success' do
      expect(result).to be_successful
    end

    it 'returns a Scenario as the result value' do
      expect(result.value).to be_a(Engine::Scenario)
    end

    it 'sets the scenario attributes' do
      expect(result.value.to_h.except(:owner, :scaling)).to eq({
        id: response_data['id'],
        area_code: response_data['area_code'],
        balanced_values: response_data['balanced_values'],
        end_year: response_data['end_year'],
        keep_compatible: response_data['keep_compatible'],
        metadata: response_data['metadata'],
        private: response_data['private'],
        user_values: response_data['user_values'],
        esdl_exportable: response_data['esdl_exportable'],
        coupling: response_data['coupling'],
        template: response_data['template'],
        url: response_data['url'],
        created_at: Time.parse(response_data['created_at']).utc,
        updated_at: Time.parse(response_data['updated_at']).utc
      })
    end

    it 'has no owner' do
      expect(result.value.owner).to be_nil
    end

    it 'has no scaling' do
      expect(result.value.scaling).to be_nil
    end
  end

  context 'when the scenario has an owner' do
    let(:client) do
      Faraday.new do |builder|
        builder.adapter(:test) do |stub|
          stub.get('/api/v3/scenarios/123') do
            [
              200,
              { 'Content-Type' => 'application/json' },
              response_data.merge('owner' => { 'id' => 1, 'name' => 'John Doe' })
            ]
          end
        end
      end
    end

    it 'returns a success' do
      expect(result).to be_successful
    end

    it 'has no owner' do
      expect(result.value.owner.to_h).to eq(id: 1, name: 'John Doe')
    end
  end

  context 'when the scenario has a scaling' do
    let(:client) do
      Faraday.new do |builder|
        builder.adapter(:test) do |stub|
          stub.get('/api/v3/scenarios/123') do
            [
              200,
              { 'Content-Type' => 'application/json' },
              response_data.merge(
                'scaling' => {
                  'area_attribute' => 'number_of_residences',
                  'value' => 1000,
                  'base_value' => 2000,
                  'has_agriculture' => false,
                  'has_industry' => false,
                  'has_energy' => true
                }
              )
            ]
          end
        end
      end
    end

    it 'returns a success' do
      expect(result).to be_successful
    end

    it 'has a scaling' do
      expect(result.value.scaling.to_h).to eq(
        area_attribute: 'number_of_residences',
        value: 1000,
        base_value: 2000,
        has_agriculture: false,
        has_industry: false,
        has_energy: true
      )
    end
  end

  context 'when the response is a 404' do
    let(:client) do
      Faraday.new do |builder|
        builder.adapter(:test) do |stub|
          stub.get('/api/v3/scenarios/123') do
            raise Faraday::ResourceNotFound
          end
        end
      end
    end

    it 'returns a failure' do
      expect(result).to be_failure
    end

    it 'has an error message' do
      expect(result.errors).to eq(['Scenario not found'])
    end
  end

  context 'when the response is another error' do
    let(:client) do
      Faraday.new do |builder|
        builder.adapter(:test) do |stub|
          stub.get('/api/v3/scenarios/123') do
            raise Faraday::BadRequestError
          end
        end
      end
    end

    it 'returns a failure' do
      expect(result).to be_failure
    end

    it 'has an error message' do
      expect(result.errors).to eq(['Failed to fetch scenario'])
    end
  end
end
