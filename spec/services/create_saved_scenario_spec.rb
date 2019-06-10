# frozen_string_literal: true

require 'rails_helper'

describe CreateSavedScenario, type: :service do
  let(:user) { FactoryBot.create(:user) }
  let(:result) { described_class.call(10, user) }
  let(:result_scenario) { FactoryBot.build(:api_scenario, id: 11) }
  let(:api_result) { ServiceResult.success(result_scenario) }

  before do
    allow(CreateAPIScenario).to receive(:call)
      .with(hash_including(scenario_id: 10))
      .and_return(api_result)
  end

  context 'when the API response is successful' do
    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is successful' do
      expect(result).to be_successful
    end

    it 'returns the scenario as the value' do
      expect(result.value).to be_a(SavedScenario)
    end

    it 'saves the SavedScenario' do
      expect(result.value).to be_persisted
    end

    it 'sets the SavedScenario scenario ID to the new scenario' do
      expect(result.value.scenario_id).to eq(result_scenario.id)
    end

    it 'assigns the user to the saved scenario' do
      expect(result.value.user).to eq(user)
    end

    it 'sets the API scenario on the SavedScenario' do
      # Not setting the scenario would fail the test when VCR raises an error (no
      # scenario set will cause SavedScenario to fetch the data from ETEngine).
      expect(result.value.scenario).not_to be_nil
    end
  end

  context 'when given a title' do
    let(:result) { described_class.call(10, user, title: 'Hello!') }

    it 'provides the title to the CreateAPIScenario service' do
      result

      expect(CreateAPIScenario).to have_received(:call)
        .with(hash_including(title: 'Hello!'))
    end

    it 'sets the SavedScenario title' do
      expect(result.value.title).to eq('Hello!')
    end
  end

  context 'when the API response is unsuccessful' do
    let(:api_result) { ServiceResult.failure(['Nope']) }

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is not successful' do
      expect(result).not_to be_successful
    end

    it 'returns the scenario error messages' do
      expect(result.errors).to eq(['Nope'])
    end
  end

  context 'when the saved scenario is invalid' do
    let(:user) { nil }

    before do
      allow(UnprotectAPIScenario).to receive(:call)
    end

    it 'is not successful' do
      expect(result).not_to be_successful
    end

    it 'returns the saved scenario error messages' do
      expect(result.errors).to eq(["User can't be blank"])
    end

    it 'unprotects the scenario' do
      result

      expect(UnprotectAPIScenario)
        .to have_received(:call).with(result_scenario.id)
    end
  end
end
