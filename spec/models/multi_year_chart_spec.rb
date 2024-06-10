# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MultiYearChart, type: :model do
  describe '.destroy_old_discarded!' do
    it 'does not destroy a myc which is not discarded' do
      myc = FactoryBot.create(:multi_year_chart)

      expect { described_class.destroy_old_discarded! }
        .not_to change { described_class.exists?(myc.id) }
        .from(true)
    end

    it 'does not destroy a recently discarded myc' do
      myc = FactoryBot.create(:multi_year_chart, discarded_at: Time.zone.now)

      expect { described_class.destroy_old_discarded! }
        .not_to change { described_class.exists?(myc.id) }
        .from(true)
    end

    it 'does not delete a discarded myc on the threshold of being old' do
      myc = FactoryBot.create(
        :multi_year_chart,
        discarded_at: (MultiYearChart::AUTO_DELETES_AFTER - 10.seconds).ago
      )

      expect { described_class.destroy_old_discarded! }
        .not_to change { described_class.exists?(myc.id) }
        .from(true)
    end

    it 'destroys an old discarded myc' do
      myc = FactoryBot.create(
        :multi_year_chart,
        discarded_at: (MultiYearChart::AUTO_DELETES_AFTER + 10.seconds).ago
      )

      expect { described_class.destroy_old_discarded! }
        .to change { described_class.exists?(myc.id) }
        .from(true).to(false)
    end
  end

  describe '#latest_scenario_ids' do
    let(:user) { create(:user) }
    let(:myc) { create(:multi_year_chart, user: user) }

    context 'with only myc_scenarios' do
      it 'returns the scenario ids' do
        expect(myc.latest_scenario_ids).to include(myc.scenarios.first.scenario_id)
      end
    end

    context 'with myc_scenarios and saved scenarios' do
      before do
        saved_scenario = create(:saved_scenario, scenario_id: 111, user: user)
        create(:multi_year_chart_saved_scenario, multi_year_chart: myc, saved_scenario: saved_scenario)
      end

      it 'returns the scenairo ids' do
        expect(myc.latest_scenario_ids).to include(111)
      end
    end
  end
end
