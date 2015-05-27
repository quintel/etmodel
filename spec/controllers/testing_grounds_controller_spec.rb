require 'spec_helper'

describe TestingGroundsController do
  let(:scenario_mock) { ete_scenario_mock }
  let(:user){ FactoryGirl.create(:user) }

  describe "#create" do
    before do
      login_as user
      Api::Scenario.stub(:create).and_return scenario_mock

      post :create
    end

    it 'creates a scenario' do
      expect(SavedScenario.count).to eq(1)
    end

    it "redirects to ETMoses" do
      expect(response).to redirect_to("http://localhost:3002/testing_grounds/import?scenario_id=")
    end
  end
end
