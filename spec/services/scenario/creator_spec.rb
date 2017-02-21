require 'rails_helper'

describe Scenario::Creator do
  let(:scenario_mock) { ete_scenario_mock }

  it "creates a scenario" do
    user = FactoryGirl.create(:user)
    allow(Api::Scenario).to receive(:create).and_return scenario_mock

    Scenario::Creator.new(user, {}).create

    expect(SavedScenario.count).to eq(1)
  end
end
