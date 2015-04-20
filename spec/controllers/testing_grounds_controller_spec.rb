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

    it "redirects to ivy" do
      expect(response).to redirect_to("http://ivy.com")
    end
  end
end
