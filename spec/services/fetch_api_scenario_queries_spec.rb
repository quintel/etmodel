# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchAPIScenarioQueries do
  let(:result) { described_class.call(client, 123, %w[query_one query_two]) }

  context 'when the response contains data for two queries' do
    let(:client) do
      Faraday.new do |builder|
        builder.adapter(:test) do |stub|
          stub.put('/api/v3/scenarios/123') do
            [
              200,
              { 'Content-Type' => 'application/json' },
              {
                'gqueries' => {
                  'query_one' => {
                    'present' => 1,
                    'future' => 2,
                    'unit' => 'MW'
                  },
                  'query_two' => {
                    'present' => 10,
                    'future' => 20,
                    'unit' => 'PJ'
                  }
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

    it 'includes the first query' do
      expect(result.value['query_one'].to_h).to eq({
        key: 'query_one',
        present: 1.0,
        future: 2.0,
        unit: 'MW'
      })
    end

    it 'includes the second query' do
      expect(result.value['query_two'].to_h).to eq({
        key: 'query_two',
        present: 10.0,
        future: 20.0,
        unit: 'PJ'
      })
    end
  end

  context 'when the response is a 404' do
    let(:client) do
      Faraday.new do |builder|
        builder.adapter(:test) do |stub|
          stub.put('/api/v3/scenarios/123') do
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
          stub.put('/api/v3/scenarios/123') do
            raise Faraday::BadRequestError
          end
        end
      end
    end

    it 'returns a failure' do
      expect(result).to be_failure
    end

    it 'has an error message' do
      expect(result.errors).to eq(['Failed to fetch queries'])
    end
  end
end
