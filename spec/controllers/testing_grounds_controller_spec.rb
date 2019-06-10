require 'rails_helper'

describe TestingGroundsController do
  let(:scenario_mock) { ete_scenario_mock }
  let(:user) { FactoryBot.create(:user) }

  describe '#create' do
    before do
      login_as user

      allow(CreateAPIScenario).to receive(:call).and_return(
        ServiceResult.success(scenario_mock)
      )

      post :create
    end

    it 'creates a scenario' do
      expect(SavedScenario.count).to eq(1)
    end

    it 'redirects to ETMoses' do
      expect(response.redirect_url).to include("testing_grounds/import?scenario_id=")
    end
  end
end
