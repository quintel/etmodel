class AddPolicyGoalsToDatabase < ActiveRecord::Migration

  def self.up
        PolicyGoal.create!(:key => 'co2_emission', :name => 'CO2',
            :query => 'UNIT(Q(co2_emission_total);billions)',
            :display_format => 'percentage', :unit => 'co2_pct', :start_value_query => 'UNIT(Q(co2_emission_total);billions)',
            :reached_query => 'LESS_OR_EQUAL(UNIT(Q(co2_emission_total);billions),GOAL(co2_emission))')

        PolicyGoal.create!(:key => 'net_energy_import', :name => 'Dependence',
            :query => 'Q(energy_dependence)',
            :display_format => 'percentage', :unit => 'pct', :start_value_query => "Q(energy_dependence)",
            :reached_query => 'LESS_OR_EQUAL(Q(energy_dependence),GOAL(energy_dependence;target))')

        PolicyGoal.create!(:key => 'net_electricity_import', :name => 'net_electricity_import',
            :query => 'Q(electricity_dependence)',
            :display_format => 'percentage', :unit => 'pct', :start_value_query => "Q(electricity_dependence)",
            :reached_query => 'LESS_OR_EQUAL(Q(electricity_dependence),GOAL(electricity_dependence;target))')

        PolicyGoal.create!(:key => 'total_energy_cost', :name => 'Cost (bln)',
            :query => 'UNIT(Q(cost_total);billions)',
            :display_format => 'number', :unit => 'eur', :start_value_query => "UNIT(Q(cost_total);billions)",
            :reached_query => 'LESS_OR_EQUAL(UNIT(Q(cost_total);billions),GOAL(total_energy_cost))')

        PolicyGoal.create!(:key => 'electricity_cost', :name => 'Electricity cost',
            :query => 'Q(avg_total_cost_for_electricity_production_per_mj)',
            :display_format => 'number', :unit => 'eur', :start_value_query => "Q(avg_total_cost_for_electricity_production_per_mj)",
            :reached_query => 'LESS_OR_EQUAL(Q(avg_total_cost_for_electricity_production_per_mj),GOAL(electricity_cost)')

        PolicyGoal.create!(:key => 'renewable_percentage', :name => 'Renewables',
            :query => 'Q(share_of_renewable_energy)',
            :display_format => 'percentage', :unit => 'pct', :start_value_query => "Q(share_of_renewable_energy)",
            :reached_query => 'GREATER_OR_EQUAL(Q(share_of_renewable_energy),GOAL(renewable_percentage)')

        PolicyGoal.create!(:key => 'onshore_land', :name => 'onshore_land',
            :query => 'V(wind_inland_energy;total_land_use)',
            :display_format => 'number_with_unit', :unit => 'km2', :start_value_query => "UNIT(DIVIDE(V(wind_inland_energy;total_land_use),AREA(onshore_suitable_for_wind));percentage)",
            :reached_query => 'LESS_OR_EQUAL(V(wind_inland_energy;total_land_use),GOAL(onshore_land)')

        PolicyGoal.create!(:key => 'onshore_coast', :name => 'onshore_coast',
            :query => 'V(wind_coastal_energy;total_land_use)',
            :display_format => 'number_with_unit', :unit => 'km', :start_value_query => "UNIT(DIVIDE(V(wind_coastal_energy;total_land_use),AREA(offshore_suitable_for_wind));percentage)",
            :reached_query => 'LESS_OR_EQUAL(V(wind_coastal_energy;total_land_use),GOAL(onshore_coast)')

        PolicyGoal.create!(:key => 'offshore', :name => 'offshore',
            :query => 'V(wind_offshore_energy;total_land_use)',
            :display_format => 'number_with_unit', :unit => 'km2', :start_value_query => "UNIT(DIVIDE(V(wind_offshore_energy;total_land_use),AREA(offshore_suitable_for_wind));percentage)",
            :reached_query => 'LESS_OR_EQUAL(V(wind_offshore_energy;total_land_use),GOAL(offshore)')

        PolicyGoal.create!(:key => 'roofs_for_solar_panels', :name => 'roofs_for_solar_panels',
            :query => 'V(local_solar_pv_grid_connected_energy_energetic;total_land_use)',
            :display_format => 'number_with_unit', :unit => 'km2', :start_value_query => "Q(roof_pv_percentage_used)",
            :reached_query => 'LESS_OR_EQUAL(V(local_solar_pv_grid_connected_energy_energetic;total_land_use),GOAL(roofs_for_solar_panels)')

        PolicyGoal.create!(:key => 'land_for_solar_panels', :name => 'land_for_solar_panels',
            :query => 'V(solar_pv_central_production_energy_energetic;total_land_use)',
            :display_format => 'number_with_unit', :unit => 'km2', :start_value_query => "Q(land_pv_percentage_used)",
            :reached_query => 'LESS_OR_EQUAL(V(solar_pv_central_production_energy_energetic;total_land_use),GOAL(land_for_solar_panels)')

        PolicyGoal.create!(:key => 'land_for_csp', :name => 'Land for CSP',
            :query => 'V(solar_csp_energy;total_land_use)',
            :display_format => 'number_with_unit', :unit => 'km2', :start_value_query => "Q(land_csp_percentage_used)",
            :reached_query => 'LESS_OR_EQUAL(V(solar_csp_energy;total_land_use),GOAL(land_for_csp)')
  end

  def self.down
    # no harm done by leaving data in db
  end
end
