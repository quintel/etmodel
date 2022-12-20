# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchAPIScenarioInputs do
  let(:result) { described_class.call(client, 123) }

  context 'when the response contains data for two inputs' do
    let(:client) do
      Faraday.new do |builder|
        builder.adapter(:test) do |stub|
          stub.get('/api/v3/scenarios/123/inputs') do
            [
              200,
              { 'Content-Type' => 'application/json' },
              {
                'input_one' => {
                  'min' => 1,
                  'max' => 2,
                  'default' => 1,
                  'unit' => 'MW'
                },
                'input_two' => {
                  'min' => nil,
                  'max' => nil,
                  'default' => 'foo',
                  'unit' => 'enum',
                  'disabled' => true
                }
              }
            ]
          end
        end
      end
    end

    it 'returns a success' do
      expect(result).to be_successful
    end

    it 'returns a hash as the result value' do
      expect(result.value).to be_a(Hash)
    end

    it 'includes the first input' do
      expect(result.value['input_one'].to_h).to eq({
        key: 'input_one',
        min: 1,
        max: 2,
        default: 1,
        unit: 'MW'
      })
    end

    it 'includes the second input' do
      expect(result.value['input_two'].to_h).to eq({
        key: 'input_two',
        min: nil,
        max: nil,
        default: 'foo',
        unit: 'enum',
        disabled: true
      })
    end
  end

  context 'when the response is a 404' do
    let(:client) do
      Faraday.new do |builder|
        builder.adapter(:test) do |stub|
          stub.get('/api/v3/scenarios/123/inputs') do
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
          stub.get('/api/v3/scenarios/123/inputs') do
            raise Faraday::BadRequestError
          end
        end
      end
    end

    it 'returns a failure' do
      expect(result).to be_failure
    end

    it 'has an error message' do
      expect(result.errors).to eq(['Failed to fetch inputs'])
    end
  end
end
