require 'rails_helper'

describe ScenarioHelper do

  class ScenarioHelperTester
    include ScenarioHelper
    attr_accessor :saved_scenario
  end

  let(:saved_scenario) do
    saved_scenario = double('SavedScenario')
    allow(saved_scenario).to receive(:persisted?).and_return true
    saved_scenario
  end

  subject {  ScenarioHelperTester.new }

  describe '#save_scenario_enabled?' do
    it "with a saved_scenario available" do
      subject.saved_scenario = saved_scenario
      expect(subject.save_scenario_enabled?).to be_truthy
    end

    it "without saved_scenario available" do
      expect(subject.save_scenario_enabled?).to be_falsy
    end
  end
end
