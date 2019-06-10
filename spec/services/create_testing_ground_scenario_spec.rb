# frozen_string_literal: true

require 'rails_helper'

describe CreateTestingGroundScenario, type: :service do
  context 'when a user is provided' do
    let(:user) { FactoryBot.create(:user) }
    let(:result) { described_class.call(10, user) }

    before do
      allow(CreateSavedScenario).to receive(:call).and_return(
        ServiceResult.success(
          FactoryBot.build(
            :saved_scenario,
            scenario: FactoryBot.build(:api_scenario)
          )
        )
      )
    end

    it 'calls the CreateSavedScenario service' do
      result

      expect(CreateSavedScenario).to have_received(:call).with(
        10, user, scenario_id: 10, title: '10 scaled'
      )
    end

    it 'returns the Api::Scenario' do
      expect(result.value).to be_a(Api::Scenario)
    end
  end

  context 'when no user is provided' do
    let(:result) { described_class.call(10, nil) }

    before do
      allow(CreateAPIScenario).to receive(:call).and_return(
        ServiceResult.success(FactoryBot.build(:api_scenario))
      )
    end

    it 'calls the CreateAPIScenario service' do
      result

      expect(CreateAPIScenario)
        .to have_received(:call).with(scenario_id: 10, title: '10 scaled')
    end

    it 'returns the Api::Scenario' do
      expect(result.value).to be_a(Api::Scenario)
    end
  end
end
