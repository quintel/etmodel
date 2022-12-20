# frozen_string_literal: true

require 'rails_helper'

describe CreateAPIScenario, type: :service do
  let(:client) do
    Faraday.new do |builder|
      builder.adapter(:test) do |stub|
        stub.post('/api/v3/scenarios') do |_env|
          response
        end
      end
    end
  end

  let(:result) { described_class.call(client, attributes) }

  let(:attributes) do
    {
      area_code: 'nl',
      end_year: 2050,
      scenario_id: nil,
      source: 'ETM'
    }
  end

  context 'when the response is successful' do
    let(:response) do
      [
        200,
        { 'Content-Type' => 'application/json' },
        attributes_for(:engine_scenario, attributes.stringify_keys.merge(
          'balanced_values' => {},
          'esdl_exportable' => false,
          'id' => 123,
          'keep_compatible' => false,
          'metadata' => {},
          'private' => false,
          'user_values' => {},
          'owner' => {
            'id' => 456,
            'name' => 'John Doe'
          }
        ))
      ]
    end

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is successful' do
      expect(result).to be_successful
    end

    it 'returns the scenario as the value' do
      expect(result.value.to_h).to include({
        id: 123,
        area_code: 'nl',
        end_year: 2050
      })
    end

    it 'sets the owner' do
      expect(result.value.owner).to be_a(Engine::User)
      expect(result.value.owner.to_h).to eq(id: 456, name: 'John Doe')
    end
  end

  context 'when the response is unsuccessful' do
    let(:response) do
      raise stub_faraday_422('Area code is unknown or not supported')
    end

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is not successful' do
      expect(result).not_to be_successful
    end

    it 'returns the scenario error messages' do
      expect(result.errors).to eq(['Area code is unknown or not supported'])
    end
  end
end
