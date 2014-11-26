require 'spec_helper'

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

    it 'does not have agriculture' do
      expect(scaled.has_agriculture?).to be_false
      expect(scaled.has_agriculture).to be_false
      expect(scaled.attributes[:has_agriculture]).to be_false
    end

    it 'does not have industry' do
      expect(scaled.has_industry?).to be_false
      expect(scaled.has_industry).to be_false
      expect(scaled.attributes[:has_industry]).to be_false
    end
  end
end
