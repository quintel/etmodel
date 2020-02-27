# frozen_string_literal: true

require 'rails_helper'

describe UpdateSavedScenario, type: :service do
  let(:user) { FactoryBot.create(:user) }
  let(:result_scenario) { FactoryBot.build(:api_scenario, id: 11) }
  let(:api_result)  { ServiceResult.success(result_scenario) }
  let(:result) { described_class.call(saved_scenario, 10) }
  let!(:saved_scenario) do
    FactoryBot.create :saved_scenario,
                      user: user,
                      id: 648695
  end

  before do
    allow(CreateAPIScenario).to receive(:call)
      .and_return(api_result)
    allow(saved_scenario).to receive(:scenario)
      .and_return(ete_scenario_mock)

    saved_scenario.title = nil
  end

  context 'when the API response is successful' do
    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is successful' do
      expect(result).to be_successful
    end

    describe '#value' do
      subject { result.value }
      it { is_expected.to be_a SavedScenario }
      it { is_expected.to be_persisted }
    end

    it 'changes the scenario_id on the SavedScenario' do
      expect{ result }
        .to change{ saved_scenario.scenario_id }
                .from(648695)
                .to(11)
    end

    it 'sets the title saved scenario to the one of old scenario' do
      expect{ result }
        .to change{ saved_scenario.title }
              .from(nil)
              .to("title")
    end

    it 'sets the saved scenario description to the one of old scenario' do
      expect{ result }
        .to change{ saved_scenario.description }
              .from(nil)
              .to("description")
    end

    it 'changes the scenario_id_history on the SavedScenario' do
      expect{ result }
        .to change{ saved_scenario.scenario_id_history }
              .from([])
              .to([648695])
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
end
