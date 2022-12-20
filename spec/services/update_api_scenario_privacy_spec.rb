# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateAPIScenarioPrivacy do
  let(:result) { described_class.call(client, 123, private: true) }

  context 'when the scenario is accessible' do
    let(:client) do
      Faraday.new do |builder|
        builder.adapter(:test) do |stub|
          stub.put('/api/v3/scenarios/123', { scenario: { private: true } }) do
            [
              200,
              { 'Content-Type' => 'application/json' },
              {}
            ]
          end
        end
      end
    end

    it 'returns a successful result' do
      expect(result).to be_successful
    end
  end
end
