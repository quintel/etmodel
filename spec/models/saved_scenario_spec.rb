require 'spec_helper'

describe SavedScenario do
  it { is_expected.to belong_to :user }

  describe "#scenario" do
    it "returns nil if scenario is not found in ET-Engine" do
      expect(Api::Scenario).to receive(:find).with(0).and_raise(ActiveResource::ResourceNotFound.new(404))
      expect(SavedScenario.new(scenario_id: 0).scenario).to be_nil
    end
  end

  describe "#scenario=" do
    before(:each) do
      @saved_scenario_new = SavedScenario.new(scenario_id: 0)
      @saved_scenario_db = FactoryGirl.create(:saved_scenario)
    end

    it "assigns a new id if new id is not nil" do
      expect{ @saved_scenario_new.scenario = @saved_scenario_db }
        .to change{ @saved_scenario_new.scenario_id }.from(0).to(@saved_scenario_db.id)
    end

    it "does not assign a new id if the new id is nil" do
      @saved_scenario_db  = nil
      expect{ @saved_scenario_new.scenario = @saved_scenario_db }
        .to_not change{ @saved_scenario_new.scenario_id }
    end
  end
end
