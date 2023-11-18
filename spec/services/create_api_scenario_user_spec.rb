# frozen_string_literal: true

require 'rails_helper'

describe CreateAPIScenarioUser, type: :service do
  let(:client) do
    Faraday.new do |builder|
      builder.adapter(:test) do |stub|
        stub.post('/api/v3/scenarios/123/users') do |_env|
          response
        end
      end
    end
  end

  let(:scenario_user) { { id: 1, email: nil, role: 'scenario_owner' } }
  let(:result) { described_class.call(client, 123, scenario_user) }


  context 'when the response is successful' do
    let(:response) do
      [
        200,
        { 'Content-Type' => 'application/json' },
        { id: 1, email: nil, role: 'scenario_owner' }
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
        id: 1,
        email: nil,
        role: 'scenario_owner'
      })
    end
  end

  context 'when the response is unsuccessful' do
    let(:response) do
      raise stub_faraday_422('Id is invalid')
    end

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is not successful' do
      expect(result).not_to be_successful
    end

    it 'returns the scenario error messages' do
      expect(result.errors).to eq(['Failed to create scenario user: '])
    end
  end
end

