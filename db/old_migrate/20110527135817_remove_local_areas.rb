class RemoveLocalAreas < ActiveRecord::Migration
  def self.up
    drop_table :areas
  end

  def self.down
    create_table "areas", :force => true do |t|
      t.string   "country"
      t.float    "co2_price"
      t.float    "co2_percentage_free"
      t.float    "el_import_capacity"
      t.float    "el_export_capacity"
      t.float    "co2_emission_1990"
      t.float    "co2_emission_2009"
      t.float    "co2_emission_electricity_1990"
      t.float    "residences_roof_surface_available_for_pv"
      t.float    "coast_line"
      t.float    "offshore_suitable_for_wind"
      t.float    "onshore_suitable_for_wind"
      t.float    "areable_land"
      t.float    "available_land"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.float    "land_available_for_solar"
      t.float    "km_per_car"
      t.float    "import_electricity_primary_demand_factor",              :default => 1.82
      t.float    "export_electricity_primary_demand_factor",              :default => 1.0
      t.float    "capacity_buffer_in_mj_s"
      t.float    "capacity_buffer_decentral_in_mj_s"
      t.float    "km_per_truck"
      t.float    "annual_infrastructure_cost_electricity"
      t.float    "number_of_residences"
      t.float    "number_of_inhabitants"
      t.boolean  "use_network_calculations"
      t.boolean  "has_coastline"
      t.boolean  "has_mountains"
      t.boolean  "has_lignite"
      t.float    "annual_infrastructure_cost_gas"
      t.string   "entity"
      t.float    "percentage_of_new_houses"
      t.float    "recirculation"
      t.float    "heat_recovery"
      t.float    "ventilation_rate"
      t.float    "market_share_daylight_control"
      t.float    "market_share_motion_detection"
      t.float    "buildings_heating_share_offices"
      t.float    "buildings_heating_share_schools"
      t.float    "buildings_heating_share_other"
      t.float    "buildings_roof_surface_available_for_pv"
      t.float    "insulation_level_existing_houses"
      t.float    "insulation_level_new_houses"
      t.float    "insulation_level_schools"
      t.float    "insulation_level_offices"
      t.boolean  "has_buildings"
      t.boolean  "has_agriculture",                                       :default => true
      t.integer  "current_electricity_demand_in_mj",         :limit => 8, :default => 1
      t.boolean  "has_solar_csp"
      t.boolean  "has_old_technologies"
      t.integer  "parent_id"
    end    
  end
end
