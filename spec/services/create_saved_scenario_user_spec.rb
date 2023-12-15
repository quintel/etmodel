# frozen_string_literal: true

require 'rails_helper'

describe CreateSavedScenarioUser, type: :service do
  let(:client) { instance_double(Faraday::Connection) }
  let(:user) { FactoryBot.create(:user) }
  let(:email) { 'hello@me.com' }
  let(:new_viewer_user_params) { { role_id: 1, user_email: email } }
  let(:api_result) { ServiceResult.success }
  let(:result) { described_class.call(client, saved_scenario, user.name, new_viewer_user_params) }
  let!(:saved_scenario) do
    FactoryBot.create :saved_scenario,
                      user: user,
                      id: 648_695
  end

  before do
    allow(CreateAPIScenarioUser).to receive(:call)
      .and_return(api_result)
    # allow(saved_scenario).to receive(:scenario)
    #   .and_return(ete_scenario_mock)
  end

  context 'when the API responses are successful and the record is valid' do
    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is successful' do
      expect(result).to be_successful
    end

    describe '#value' do
      subject { result.value }

      it { is_expected.to be_a SavedScenarioUser }
      it { is_expected.to be_persisted }
    end

    it 'changes the viewers on the SavedScenario' do
      expect { result }.to change(
        saved_scenario.saved_scenario_users, :count
        ).from(1).to(2)
    end
  end

  context 'when the record was invalid' do
    let(:new_viewer_user_params) { { role_id: 1, user_email: 'ppp' } }

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is not successful' do
      expect(result).not_to be_successful
    end

    it 'returns the scenario error messages' do
      expect(result.errors).to eq([:user_email])
    end
  end

  context 'when the new user was already invited' do
    before do
      SavedScenarioUser.create!(role_id: 2, user_email: email, saved_scenario: saved_scenario)
    end

    it 'returns a ServiceResult' do
      expect(result).to be_a(ServiceResult)
    end

    it 'is not successful' do
      expect(result).not_to be_successful
    end

    it 'returns the scenario error messages' do
      expect(result.errors).to eq(['duplicate'])
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
