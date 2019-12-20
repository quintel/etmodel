class AddColectiveHeatMekko < ActiveRecord::Migration[5.2]

  COLORS = {
    'other_final_demand_steam_hot_water_in_collective_heat_network_mekko' => '#786FA6',
    'energy_heat_unused_steam_hot_water_in_collective_heat_network_mekko' => '#FF8C8C',
    'energy_heat_well_geothermal_in_collective_heat_network_mekko' => '#FFA502',
    'households_final_demand_steam_hot_water_in_collective_heat_network_mekko' => '#E69567',
    'energy_heat_burner_wood_pellets_in_collective_heat_network_mekko' => '#009432',
    'energy_heat_distribution_loss_in_collective_heat_network_mekko' => '#800080',
    'energy_heat_heatpump_water_water_electricity_in_collective_heat_network_mekko' => '#ADD8E6',
    'energy_heat_import_steam_hot_water_in_collective_heat_network_mekko' => '#e61919',
    'energy_heat_solar_thermal_in_collective_heat_network_mekko' => '#FFD700',
    'energy_heat_backup_burner_network_gas_in_collective_heat_network_mekko' => '#CED6E0',
    'energy_heat_burner_crude_oil_in_collective_heat_network_mekko' => '#CD6133',
    'energy_heat_burner_hydrogen_in_collective_heat_network_mekko' => '#87CEEB',
    'energy_heat_burner_network_gas_in_collective_heat_network_mekko' => '#A4B0BE',
    'energy_heat_burner_waste_mix_in_collective_heat_network_mekko' => '#006266',
    'energy_chp_supercritical_waste_mix_in_collective_heat_network_mekko' => '#218C74',
    'energy_chp_ultra_supercritical_lignite_in_collective_heat_network_mekko' => '#222F3E',
    'energy_chps_coal_in_collective_heat_network_mekko' => '#485460',
    'energy_chp_local_engine_network_gas_in_collective_heat_network_mekko' => '#DFE4EA',
    'energy_chp_local_wood_pellets_in_collective_heat_network_mekko' => '#3D6B0D',
    'buildings_final_demand_steam_hot_water_in_collective_heat_network_mekko' => '#F9CA24',
    'energy_chp_combined_cycle_network_gas_in_collective_heat_network_mekko' => '#A4B0BE',
    'energy_chp_local_engine_biogas_in_collective_heat_network_mekko' => '#CE8814',
    'agriculture_final_demand_steam_hot_water_in_collective_heat_network_mekko' => '#6AB04C',
    'energy_heat_burner_coal_in_collective_heat_network_mekko' => '#333333'
  }

  def up
     ActiveRecord::Base.transaction do
      el = OutputElement.create!(
        key: :collective_heat_mekko,
        group: 'Supply',
        output_element_type: OutputElementType.find_by_name(:mekko),
        sub_group: 'collective_heat',
        unit: 'MJ'
      )

      create_output_series(el, 'other_final_demand_steam_hot_water_in_collective_heat_network_mekko', 'other_final_demand_steam_hot_water_in_collective_heat_network_mekko',5,group: "demand")
      create_output_series(el, 'energy_heat_unused_steam_hot_water_in_collective_heat_network_mekko', 'energy_heat_unused_steam_hot_water_in_collective_heat_network_mekko',1,group: "demand")
      create_output_series(el, 'energy_heat_well_geothermal_in_collective_heat_network_mekko', 'energy_heat_well_geothermal_in_collective_heat_network_mekko',7,group: "supply")
      create_output_series(el, 'households_final_demand_steam_hot_water_in_collective_heat_network_mekko', 'households_final_demand_steam_hot_water_in_collective_heat_network_mekko',2,group: "demand")
      create_output_series(el, 'energy_heat_burner_wood_pellets_in_collective_heat_network_mekko', 'energy_heat_burner_wood_pellets_in_collective_heat_network_mekko',8,group: "supply")
      create_output_series(el, 'energy_heat_distribution_loss_in_collective_heat_network_mekko', 'energy_heat_distribution_loss_in_collective_heat_network_mekko',6,group: "demand")
      create_output_series(el, 'energy_heat_heatpump_water_water_electricity_in_collective_heat_network_mekko', 'energy_heat_heatpump_water_water_electricity_in_collective_heat_network_mekko',9,group: "supply")
      create_output_series(el, 'energy_heat_import_steam_hot_water_in_collective_heat_network_mekko', 'energy_heat_import_steam_hot_water_in_collective_heat_network_mekko',10,group: "supply")
      create_output_series(el, 'energy_heat_solar_thermal_in_collective_heat_network_mekko', 'energy_heat_solar_thermal_in_collective_heat_network_mekko',11,group: "supply")
      create_output_series(el, 'energy_heat_backup_burner_network_gas_in_collective_heat_network_mekko', 'energy_heat_backup_burner_network_gas_in_collective_heat_network_mekko',12,group: "supply")
      create_output_series(el, 'energy_heat_burner_crude_oil_in_collective_heat_network_mekko', 'energy_heat_burner_crude_oil_in_collective_heat_network_mekko',13,group: "supply")
      create_output_series(el, 'energy_heat_burner_hydrogen_in_collective_heat_network_mekko', 'energy_heat_burner_hydrogen_in_collective_heat_network_mekko',14,group: "supply")
      create_output_series(el, 'energy_heat_burner_network_gas_in_collective_heat_network_mekko', 'energy_heat_burner_network_gas_in_collective_heat_network_mekko',15,group: "supply")
      create_output_series(el, 'energy_heat_burner_waste_mix_in_collective_heat_network_mekko', 'energy_heat_burner_waste_mix_in_collective_heat_network_mekko',16,group: "supply")
      create_output_series(el, 'energy_chp_supercritical_waste_mix_in_collective_heat_network_mekko', 'energy_chp_supercritical_waste_mix_in_collective_heat_network_mekko',17,group: "supply")
      create_output_series(el, 'energy_chp_ultra_supercritical_lignite_in_collective_heat_network_mekko', 'energy_chp_ultra_supercritical_lignite_in_collective_heat_network_mekko',18,group: "supply")
      create_output_series(el, 'energy_chps_coal_in_collective_heat_network_mekko', 'energy_chps_coal_in_collective_heat_network_mekko',19,group: "supply")
      create_output_series(el, 'energy_chp_local_engine_network_gas_in_collective_heat_network_mekko', 'energy_chp_local_engine_network_gas_in_collective_heat_network_mekko',20,group: "supply")
      create_output_series(el, 'energy_chp_local_wood_pellets_in_collective_heat_network_mekko', 'energy_chp_local_wood_pellets_in_collective_heat_network_mekko',21,group: "supply")
      create_output_series(el, 'buildings_final_demand_steam_hot_water_in_collective_heat_network_mekko', 'buildings_final_demand_steam_hot_water_in_collective_heat_network_mekko',3,group: "demand")
      create_output_series(el, 'energy_chp_combined_cycle_network_gas_in_collective_heat_network_mekko', 'energy_chp_combined_cycle_network_gas_in_collective_heat_network_mekko',22,group: "supply")
      create_output_series(el, 'energy_chp_local_engine_biogas_in_collective_heat_network_mekko', 'energy_chp_local_engine_biogas_in_collective_heat_network_mekko',23,group: "supply")
      create_output_series(el, 'agriculture_final_demand_steam_hot_water_in_collective_heat_network_mekko', 'agriculture_final_demand_steam_hot_water_in_collective_heat_network_mekko',4,group: "demand")
      create_output_series(el, 'energy_heat_burner_coal_in_collective_heat_network_mekko', 'energy_heat_burner_coal_in_collective_heat_network_mekko',24,group: "supply")

    end
  end

  def down
    ActiveRecord::Base.transaction do
      OutputElement.find_by_key(:collective_heat_mekko).destroy!
    end
  end

  private

  def create_output_series(element, gquery, label, order_by, target_line: false, group: '')
    element.output_element_series.create!(output_series_attrs(gquery, label, order_by, target_line, group))
  end

  def output_series_attrs(gquery, label, order_by, target_line, group)
      {
        color: COLORS[gquery],
        gquery: gquery,
        is_target_line: target_line,
        label: label,
        order_by: order_by,
        group: group
      }
  end
end
