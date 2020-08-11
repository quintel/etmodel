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

  describe 'add_id_to_history' do
    it "adds the provided id to the end of its history" do
      subject.add_id_to_history("1234")
      expect(subject.scenario_id_history.last).to eq("1234")
    end

    it "increases the amount of items in the history by one" do
      expect{ subject.add_id_to_history("1234") }
        .to change{subject.scenario_id_history.count}.by 1
    end

    it "won't add more then 20 items" do
      20.times{|n| subject.add_id_to_history(n)}

      expect{ subject.add_id_to_history("1234") }
        .not_to change{subject.scenario_id_history.count}
    end
  end

  describe '.custom_curves_order' do
    subject { described_class.custom_curves_order(2050, 'nl') }

    let(:scenario_nl_2030) { FactoryBot.create(:saved_scenario, end_year: 2030) }
    let(:scenario_nl_2050) { FactoryBot.create(:saved_scenario, end_year: 2050) }
    let(:scenario_de_2030) { FactoryBot.create(:saved_scenario, end_year: 2030, area_code: 'de') }
    let(:scenario_de_2050) { FactoryBot.create(:saved_scenario, end_year: 2050, area_code: 'de') }
    let(:scenario_be_2030) { FactoryBot.create(:saved_scenario, end_year: 2030, area_code: 'be') }

    before do
      scenario_nl_2030
      scenario_nl_2050
      scenario_de_2030
      scenario_de_2050
      scenario_be_2030
    end

    it { is_expected.to include(scenario_de_2030, scenario_de_2050, scenario_be_2030) }
    it { is_expected.not_to include(scenario_nl_2030, scenario_nl_2050) }

    it 'puts the 2050 scenario first' do
      expect(subject.first).to eq(scenario_de_2050)
    end
  end

  describe 'when the scenario has no FeaturedScenario' do
    it 'is not featured' do
      expect(FactoryBot.create(:saved_scenario)).not_to be_featured
    end
  end

  describe 'when the scenario has a FeaturedScenario' do
    it 'is not featured' do
      featured = FactoryBot.create(:featured_scenario)
      expect(featured.saved_scenario).to be_featured
    end
  end

  describe '#as_json' do
    let(:scenario) { FactoryBot.create(:saved_scenario) }
    let(:json) { scenario.as_json }

    it 'includes the scenario_id attribute' do
      expect(json).to include('scenario_id' => scenario.scenario_id)
    end

    it 'includes the scenario_id_history attribute' do
      expect(json).to include('scenario_id_history' => scenario.scenario_id_history)
    end

    it 'omits the user_id attribute' do
      expect(json.keys).not_to include('user_id')
    end

    it 'omits the settings attribute' do
      expect(json.keys).not_to include('settings')
    end

    context 'with { except: :scenario_id }' do
      let(:json) { scenario.as_json(except: [:scenario_id]) }

      it 'omits the scenario_id attribute' do
        expect(json.keys).not_to include('scenario_id')
      end

      it 'includes the scenario_id_history attribute' do
        expect(json).to include('scenario_id_history' => scenario.scenario_id_history)
      end

      it 'omits the user_id attribute' do
        expect(json.keys).not_to include('user_id')
      end

      it 'omits the settings attribute' do
        expect(json.keys).not_to include('settings')
      end
    end
  end
end
