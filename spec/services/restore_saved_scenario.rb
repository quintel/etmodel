# frozen_string_literal: true

require 'rails_helper'

describe RestoreSavedScenario, type: :service do
  let(:client) { instance_double(Faraday::Connection) }
  let(:user) { create(:user) }
  let(:restore_id) { 1234 }
  let(:result) { described_class.call(client, saved_scenario, restore_id) }
  let!(:saved_scenario) do
    create(
      :saved_scenario,
      user: user,
      id: 648_695,
      scenario_id_history: [123, 1234, 12_345]
    )
  end

  before do
    allow(client).to receive(:put).with(
      '/api/v3/scenarios/12345', scenario: { keep_compatible: false }
    )
  end

  context 'when the restore is succesful' do
    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is successful' do
      expect(result).to be_successful
    end

    it 'updates the main scenario id' do
      expect { result }.to(change(saved_scenario, :scenario_id))
    end

    it 'has the given scenario id as main scenario id in the resulting saved scenario' do
      expect(result.value.scenario_id).to eq(restore_id)
    end
  end

  context 'when restoring to an unknown scenario id' do
    let(:restore_id) { 999_999 }

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is successful' do
      expect(result).not_to be_successful
    end

    it 'did not change the main scenario id' do
      expect { result }.not_to(change(saved_scenario, :scenario_id))
    end
  end
end
