require 'rails_helper'

describe SavedScenario do
  it { is_expected.to have_many(:users).through(:saved_scenario_users) }

  # AR attributes
  it { is_expected.to respond_to :scenario_id_history }

  describe "#scenario_id_history" do
    subject { SavedScenario.new.scenario_id_history }
    it { is_expected.to be_a Array }
  end

  describe "#scenario" do
    it "returns nil if scenario is not found in ETEngine" do
      allow(FetchAPIScenario).to receive(:call)
        .with(anything, 0).and_return(ServiceResult.failure('Scenario not found'))

      expect(described_class.new(scenario_id: 0).scenario(Identity.http_client)).to be_nil
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

  describe '.create_new_version' do
    let(:saved_scenario) { create(:saved_scenario) }
    let(:user) { create(:user) }

    context 'when called without a user' do
      it 'returns false' do
        expect(saved_scenario.create_new_version(nil)).to be_falsey
      end
    end

    context 'when called with a user' do
      it 'creates a new SavedScenarioVersion for the SavedScenario' do
        expect { saved_scenario.create_new_version(user) }
          .to change { saved_scenario.saved_scenario_versions.count }
          .from(1).to(2)
      end

      it 'updated the saved_scenario_version_id' do
        expect { saved_scenario.create_new_version(user) }
          .to change(saved_scenario, :saved_scenario_version_id)
      end
    end
  end

  describe '.set_version_as_current' do
    let(:saved_scenario) { create(:saved_scenario) }
    let!(:new_version) { create(:saved_scenario_version, saved_scenario: saved_scenario) }
    let!(:newer_version) { create(:saved_scenario_version, saved_scenario: saved_scenario) }

    context 'when version is nil' do
      it 'returns false' do
        expect(saved_scenario.set_version_as_current(nil)).to be_falsey
      end
    end

    context 'when version is present' do
      it 'updates the saved_scenario_version_id' do
        saved_scenario.set_version_as_current(new_version)
        expect(saved_scenario.saved_scenario_version_id).to eq(new_version.id)
      end
    end

    context 'when revert is omitted' do
      it 'does not destroy all versions created after the given version' do
        saved_scenario.set_version_as_current(new_version)
        expect(saved_scenario.saved_scenario_versions).to include(newer_version)
      end
    end

    context 'when revert is false' do
      it 'does not destroy all versions created after the given version' do
        saved_scenario.set_version_as_current(new_version, revert: false)
        expect(saved_scenario.saved_scenario_versions).to include(newer_version)
      end
    end

    context 'when revert is true' do
      it 'destroys all versions created after the given version' do
        saved_scenario.set_version_as_current(new_version, revert: true)
        expect(saved_scenario.saved_scenario_versions).not_to include(newer_version)
      end
    end
  end

  describe '.custom_curves_order' do
    subject { described_class.custom_curves_order(2050, 'nl') }

    let(:scenario_nl_2030) { FactoryBot.create(:saved_scenario, end_year: 2030) }
    let(:scenario_nl_2050) { FactoryBot.create(:saved_scenario, end_year: 2050) }
    let(:scenario_de_2030) { FactoryBot.create(:saved_scenario, end_year: 2030, area_code: 'DE_germany') }
    let(:scenario_de_2050) { FactoryBot.create(:saved_scenario, end_year: 2050, area_code: 'DE_germany') }
    let(:scenario_be_2030) { FactoryBot.create(:saved_scenario, end_year: 2030, area_code: 'BE_belgium') }

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

  describe '.available' do
    let!(:scenario) { FactoryBot.create(:saved_scenario) }

    it 'includes active scenarios' do
      expect(described_class.available).to include(scenario)
    end

    it 'omits discarded scenarios' do
      discarded = FactoryBot.create(:saved_scenario, discarded_at: Time.zone.now)
      expect(described_class.available).not_to include(discarded)
    end

    it 'omits scenarios for unsupported regions' do
      invalid = FactoryBot.create(:saved_scenario, area_code: 'invalid')
      expect(described_class.available).not_to include(invalid)
    end
  end

  describe '.destroy_old_discarded!' do
    it 'does not destroy a scenario which is not discarded' do
      scenario = FactoryBot.create(:saved_scenario)

      expect { described_class.destroy_old_discarded! }
        .not_to change { described_class.exists?(scenario.id) }
        .from(true)
    end

    it 'does not destroy a recently discarded scenario' do
      scenario = FactoryBot.create(:saved_scenario, discarded_at: Time.zone.now)

      expect { described_class.destroy_old_discarded! }
        .not_to change { described_class.exists?(scenario.id) }
        .from(true)
    end

    it 'does not delete a discarded scenario on the threshold of being old' do
      scenario = FactoryBot.create(
        :saved_scenario,
        discarded_at: (SavedScenario::AUTO_DELETES_AFTER - 10.seconds).ago
      )

      expect { described_class.destroy_old_discarded! }
        .not_to change { described_class.exists?(scenario.id) }
        .from(true)
    end

    it 'destroys an old discarded scenario' do
      scenario = FactoryBot.create(
        :saved_scenario,
        discarded_at: (SavedScenario::AUTO_DELETES_AFTER + 10.seconds).ago
      )

      expect { described_class.destroy_old_discarded! }
        .to change { described_class.exists?(scenario.id) }
        .from(true).to(false)
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

  describe '#update_with_api_params' do
    let(:ss) { create(:saved_scenario, scenario_id: 1) }
    let(:user) { create(:user) }

    context 'when discarding a scenario' do
      it 'sets discarded at' do
        expect { ss.update_with_api_params({ discarded: true }, user) }
          .to change(ss, :discarded_at)
          .from(nil)
      end
    end

    context 'when discarding an already-discarded scenario' do
      it 'sets discarded at' do
        ss.update!(discarded_at: 1.day.ago)

        expect { ss.update_with_api_params({ discarded: true }, user) }
          .not_to change(ss, :discarded_at)
      end
    end

    context 'when undiscarding scenario' do
      it 'unsets discarded at' do
        ss.update!(discarded_at: 1.day.ago)

        expect { ss.update_with_api_params({ discarded: false }, user) }
          .to change(ss, :discarded_at)
          .to(nil)
      end
    end

    context 'when given a new scenario_id' do
      it 'returns true' do
        expect(ss.update_with_api_params({ scenario_id: 2 }, user)).to be(true)
      end

      it 'updates the scenario_id' do
        expect { ss.update_with_api_params({ scenario_id: 2 }, user) }
          .to change(ss, :scenario_id)
          .from(1).to(2)
      end

      it 'creates a new SavedScenarioVersion for the SavedScenario' do
        expect { ss.update_with_api_params({ scenario_id: 2 }, user) }
          .to change { ss.saved_scenario_versions.count }
          .from(1).to(2)
      end

      it 'updates the saved_scenario_version_id' do
        expect { ss.update_with_api_params({ scenario_id: 2 }, user) }
          .to change(ss, :saved_scenario_version_id)
      end
    end

    context 'when given no scenario_id' do
      it 'returns true' do
        expect(ss.update_with_api_params({ title: 'New title' }, user)).to be(true)
      end

      it 'does not update the scenario_id' do
        expect { ss.update_with_api_params({ title: 'New title' }, user) }
          .not_to change(ss, :scenario_id)
          .from(1)
      end

      it 'does not create a new SavedScenarioVersion for the SavedScenario' do
        expect { ss.update_with_api_params({ scenario_id: 2 }, user) }
          .to change { ss.saved_scenario_versions.count }
          .from(1).to(2)
      end


      it 'does not update the saved_scenario_version_id' do
        expect { ss.update_with_api_params({ title: 'New title' }, user) }
          .not_to change(ss, :saved_scenario_version_id)
      end
    end

    context 'when given the same scenario_id' do
      it 'returns true' do
        expect(ss.update_with_api_params({ scenario_id: 1, title: 'New title'}, user)).to be(true)
      end

      it 'does not update the scenario_id' do
        expect { ss.update_with_api_params({ scenario_id: 1, title: 'New title'}, user) }
          .not_to change(ss, :scenario_id)
          .from(1)
      end

      it 'does not create a new SavedScenarioVersion for the SavedScenario' do
        expect { ss.update_with_api_params({ scenario_id: 2 }, user) }
          .to change { ss.saved_scenario_versions.count }
          .from(1).to(2)
      end

      it 'does not update the saved_scenario_version_id' do
        expect { ss.update_with_api_params({ title: 'New title' }, user) }
          .not_to change(ss, :saved_scenario_version_id)
      end
    end
  end
end
