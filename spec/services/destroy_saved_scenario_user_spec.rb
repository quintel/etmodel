# frozen_string_literal: true

require 'rails_helper'

describe DestroySavedScenarioUser, type: :service do
  let(:client) { instance_double(Faraday::Connection) }
  let(:user) { FactoryBot.create(:user) }
  let(:saved_scenario_user) do
    viewer = FactoryBot.create(:saved_scenario_user, role_id: 1, saved_scenario: saved_scenario)
    saved_scenario.saved_scenario_users << viewer

    viewer
  end
  let(:api_result) { ServiceResult.success }
  let(:result) { described_class.call(client, saved_scenario, saved_scenario_user) }
  let!(:saved_scenario) do
    FactoryBot.create(:saved_scenario, user: user, id: 648_695)
  end

  before do
    saved_scenario_user

    allow(DestroyAPIScenarioUser).to receive(:call)
      .and_return(api_result)
  end

  context 'when the API responses are successful and the record is valid' do
    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is successful' do
      expect(result).to be_successful
    end

    it 'changes the viewers on the SavedScenario' do
      expect { result }.to change(
        saved_scenario.saved_scenario_users, :count
        ).from(2).to(1)
    end
  end

  context 'when the user was the last one left on the scenario' do
    let(:saved_scenario_user) { saved_scenario.owners.first }

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is not successful' do
      expect(result).not_to be_successful
    end

    it 'returns the scenario error messages' do
      expect(result.errors).to eq([:ownership])
    end

    it 'does not change the owner of the the SavedScenario' do
      expect { result }.not_to change(
        saved_scenario.saved_scenario_users, :count
        )
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
