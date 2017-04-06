require 'rails_helper'

module Api
  describe ScaledArea do
    let(:area) { Area.new(
      area:"nl",
      analysis_year: 2012,
      has_agriculture: true,
      has_buildings: true,
      has_climate: true,
      has_coastline: true,
      has_cold_network: false,
      has_electricity_storage: true,
      has_employment: true,
      has_fce: true,
      has_industry: true,
      has_lignite: true,
      has_merit_order: true,
      has_metal: true,
      has_mountains: true,
      has_old_technologies: true,
      has_other: true,
      has_solar_csp: true,
      has_import_export: true,
      use_network_calculations: true,
      useable: true
    ) }

    let(:scaled) { ScaledArea.new(area) }

    it 'may optionally not have agriculture' do
      Current.setting[:scaling] = { has_agriculture: false }

      begin
        expect(scaled.has_agriculture?).to be(false)
        expect(scaled.has_agriculture).to be(false)
        expect(scaled.attributes[:has_agriculture]).to be(false)
      ensure
        Current.setting[:scaling] = nil
      end
    end

    it 'may optionally have agriculture' do
      Current.setting[:scaling] = { has_agriculture: true }

      begin
        expect(scaled.has_agriculture?).to be(true)
        expect(scaled.has_agriculture).to be(true)
        expect(scaled.attributes[:has_agriculture]).to be(true)
      ensure
        Current.setting[:scaling] = nil
      end
    end

    it 'may optionally not have industry' do
      Current.setting[:scaling] = { has_industry: false }

      begin
        expect(scaled.has_industry?).to be(false)
        expect(scaled.has_industry).to be(false)
        expect(scaled.attributes[:has_industry]).to be(false)
      ensure
        Current.setting[:scaling] = nil
      end
    end

    it 'may optionally have industry' do
      Current.setting[:scaling] = { has_industry: true }

      begin
        expect(scaled.has_industry?).to be(true)
        expect(scaled.has_industry).to be(true)
        expect(scaled.attributes[:has_industry]).to be(true)
      ensure
        Current.setting[:scaling] = nil
      end
    end

    it 'does not have "other"' do
      expect(scaled.has_other?).to be(false)
      expect(scaled.has_other).to be(false)
      expect(scaled.attributes[:has_other]).to be(false)
    end

    it 'is not a national scenario' do
      expect(scaled.is_national_scenario).to be(false)
    end

    it 'a local scenario' do
      expect(scaled.is_local_scenario).to be(true)
    end
  end
end
