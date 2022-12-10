# frozen_string_literal: true

require 'rails_helper'

describe SavedScenarioPresenter, vcr: true do
  let(:scenario_mock) { ete_scenario_mock }
  let(:api_scenario) { FactoryBot.create(:api_scenario) }
  let(:saved_scenario_one) do
    FactoryBot.create(:saved_scenario, scenario: api_scenario)
  end
  let(:saved_scenario_two) do
    FactoryBot.create(:saved_scenario, scenario: api_scenario)
  end

  before do
    allow(Engine::Scenario).to receive(:find).and_return scenario_mock
  end

  context 'with two saved scenarios' do
    let(:json) do
      described_class.new([saved_scenario_one, saved_scenario_two]).as_json
    end

    it { expect(json.size).to eq 2 }
    it { expect(json[0]).to include(end_year: 2050) }
    it { expect(json[0]).to include(dataset: 'nl') }
  end

  context 'with no saved scenarios' do
    let(:json) { described_class.new([]).as_json }

    it { expect(json).to eq([]) }
  end
end
