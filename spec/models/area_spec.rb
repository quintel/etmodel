require 'spec_helper'

describe Area do

  describe "#create" do
    before(:all) do
      load_carriers
    end

    before do
      @area = Area.new(:country => 'xz')
    end

    it "should create a CarrierData for every Carrier" do
      CarrierData.should_receive(:create).with(any_args).exactly(Carrier.count).times
      @area.save
    end
  end
end



# == Schema Information
#
# Table name: areas
#
#  id                                       :integer(4)      not null, primary key
#  country                                  :string(255)
#  co2_price                                :float
#  co2_percentage_free                      :float
#  el_import_capacity                       :float
#  el_export_capacity                       :float
#  co2_emission_1990                        :float
#  co2_emission_2009                        :float
#  co2_emission_electricity_1990            :float
#  roof_surface_available_pv                :float
#  coast_line                               :float
#  offshore_suitable_for_wind               :float
#  onshore_suitable_for_wind                :float
#  areable_land                             :float
#  available_land                           :float
#  created_at                               :datetime
#  updated_at                               :datetime
#  land_available_for_solar                 :float
#  km_per_car                               :float
#  import_electricity_primary_demand_factor :float           default(1.82)
#  export_electricity_primary_demand_factor :float           default(1.0)
#  capacity_buffer_in_mj_s                  :float
#  capacity_buffer_decentral_in_mj_s        :float
#  km_per_truck                             :float
#  annual_infrastructure_cost_electricity   :float
#  number_households                        :float
#  number_inhabitants                       :float
#  use_network_calculations                 :boolean(1)
#  has_coastline                            :boolean(1)
#  has_mountains                            :boolean(1)
#  has_lignite                              :boolean(1)
#  annual_infrastructure_cost_gas           :float
#  entity                                   :string(255)
#  percentage_of_new_houses                 :float
#  recirculation                            :float
#  heat_recovery                            :float
#  ventilation_rate                         :float
#  market_share_daylight_control            :float
#  market_share_motion_detection            :float
#  buildings_heating_share_offices          :float
#  buildings_heating_share_schools          :float
#  buildings_heating_share_other            :float
#  roof_surface_available_pv_buildings      :float
#  insulation_level_existing_houses         :float
#  insulation_level_new_houses              :float
#  insulation_level_schools                 :float
#  insulation_level_offices                 :float
#  has_buildings                            :boolean(1)
#  has_agriculture                          :boolean(1)      default(TRUE)
#  current_electricity_demand_in_mj         :integer(8)      default(1)
#  has_solar_csp                            :boolean(1)
#  has_old_technologies                     :boolean(1)
#

