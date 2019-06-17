require 'rails_helper'

describe SavedScenario do
  it { is_expected.to belong_to :user }

  # AR attributes
  it { is_expected.to respond_to :scenario_id_history }

  describe "#scenario_id_history" do
    subject { SavedScenario.new.scenario_id_history }
    it { is_expected.to be_a Array }
  end

  describe "#scenario" do
    it "returns nil if scenario is not found in ET-Engine" do
      expect(Api::Scenario).to receive(:find).with(0).and_raise(ActiveResource::ResourceNotFound.new(404))
      expect(SavedScenario.new(scenario_id: 0).scenario).to be_nil
    end
  end

  describe "#scenario=" do
    before(:each) do
      @saved_scenario_new = SavedScenario.new(scenario_id: 0)
      @saved_scenario_db = FactoryBot.create(:saved_scenario)
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

  describe '#build_setting_for' do
    before(:each) do
      allow( Api::Scenario).to receive(:find){ ete_scenario_mock }
    end

    subject { FactoryBot.create(:saved_scenario) }

    it 'returns a setting' do
      expect(subject.build_setting).to be_a Setting
    end

    it 'has an active_saved_scenario_id with owner user as argument' do
      result = subject.build_setting(user: subject.user)
      expect(result.active_saved_scenario_id).to eq(subject.id)
    end

    it 'doesn\'t have an active_saved_scenario_id without an argument' do
      result = subject.build_setting
      expect(result.active_saved_scenario_id).to eq(nil)
    end
  end
end
