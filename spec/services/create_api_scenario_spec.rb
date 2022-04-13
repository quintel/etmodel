# frozen_string_literal: true

require 'rails_helper'

describe CreateApiScenario, type: :service do
  let(:result) { described_class.call(attributes) }

  let(:attributes) do
    {
      area_code: 'nl',
      end_year: 2050,
      scenario_id: nil,
      read_only: true,
      source: 'ETM'
    }
  end

  before do
    allow(Api::Scenario).to receive(:create)
      .with(scenario: { scenario: attributes })
      .and_return(scenario)
  end

  context 'when the response is successful' do
    let(:scenario) { FactoryBot.build(:api_scenario, attributes) }

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is successful' do
      expect(result).to be_successful
    end

    it 'returns the scenario as the value' do
      expect(result.value).to eq(scenario)
    end
  end

  context 'when creating an writable scenario' do
    let(:scenario) { FactoryBot.build(:api_scenario, attributes) }

    let(:attributes) do
      super().merge(read_only: false)
    end

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is successful' do
      expect(result).to be_successful
    end

    it 'creates a writable scenario' do
      result

      expect(Api::Scenario).to have_received(:create)
        .with(scenario: { scenario: hash_including(read_only: false) })
    end
  end

  context 'when the response is unsuccessful' do
    let(:scenario) do
      FactoryBot.build(:api_scenario, attributes).tap do |scen|
        scen.errors.add(:area_code, 'is not included in the list')
      end
    end

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is not successful' do
      expect(result).not_to be_successful
    end

    it 'returns the scenario error messages' do
      expect(result.errors).to eq(['Area code is not included in the list'])
    end
  end
end
