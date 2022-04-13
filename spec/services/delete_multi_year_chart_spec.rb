# frozen_string_literal: true

require 'rails_helper'

describe DeleteMultiYearChart, type: :service do
  let!(:multi_year_chart) do
    FactoryBot.create(:multi_year_chart, scenarios_count: 1)
  end

  let(:result) { described_class.call(multi_year_chart) }

  before do
    allow(SetApiScenarioCompatibility).to receive(:dont_keep_compatible)
      .with(multi_year_chart.scenarios.first.scenario_id)
  end

  it 'returns a successful result' do
    expect(result).to be_successful
  end

  it 'deletes the MultiYearChart record' do
    expect { result }.to change(MultiYearChart, :count).by(-1)
  end

  it 'deletes the MultiYearChartScenario records' do
    expect { result }.to change(MultiYearChartScenario, :count).by(-1)
  end

  it 'unprotects the remote scenarios' do
    id = multi_year_chart.scenarios.first.scenario_id
    result

    expect(SetApiScenarioCompatibility).to have_received(:dont_keep_compatible).with(id)
  end
end
