class AddHeatNetworkProductionChart < ActiveRecord::Migration[5.2]
  COLORS = {
    'heat_network_demand_curve' => '#FF0000',
    'energy_chp_combined_cycle_network_gas_steam_hot_water_output_curve' => '#A4B0BE',
    'energy_chp_local_engine_biogas_steam_hot_water_output_curve' => '#CE8814',
    'energy_chp_local_engine_network_gas_steam_hot_water_output_curve' => '#DFE4EA',
    'energy_chp_local_wood_pellets_steam_hot_water_output_curve' => '#3D6B0D',
    'energy_chp_supercritical_waste_mix_steam_hot_water_output_curve' => '#218C74',
    'energy_chp_ultra_supercritical_lignite_steam_hot_water_output_curve' => '#222F3E',
    'energy_chp_coal_steam_hot_water_output_curve' => '#485460',
    'energy_heat_backup_burner_network_gas_steam_hot_water_output_curve' => '#CED6E0',
    'energy_heat_burner_crude_oil_steam_hot_water_output_curve' => '#CD6133',
    'energy_heat_burner_coal_steam_hot_water_output_curve' => '#333333',
    'energy_heat_burner_hydrogen_steam_hot_water_output_curve' => '#FFA500',
    'energy_heat_burner_network_gas_steam_hot_water_output_curve' => '#A4B0BE',
    'energy_heat_burner_waste_mix_steam_hot_water_output_curve' => '#006266',
    'energy_heat_burner_wood_pellets_steam_hot_water_output_curve' => '#009432',
    'energy_heat_heatpump_water_water_electricity_steam_hot_water_output_curve' => '#ADD8E6',
    'energy_heat_import_steam_hot_water_steam_hot_water_output_curve' => '#FF8C8C',
    'energy_heat_solar_thermal_steam_hot_water_output_curve' => '#FFD700',
    'energy_heat_well_geothermal_steam_hot_water_output_curve' => '#FFA502',
    'energy_heat_network_storage_output_curve' => '#0984E3'
  }

  def up
     ActiveRecord::Base.transaction do
      el = OutputElement.create!(
        key: :heat_network_production,
        group: 'Supply',
        output_element_type: OutputElementType.find_by_name(:demand_curve),
        sub_group: 'heat',
        unit: 'MW'
      )

      create_output_series(el, 'heat_network_demand_curve', 'heat_network_demand', 1, target_line=true)
      create_output_series(el, 'energy_chp_combined_cycle_network_gas_steam_hot_water_output_curve', 'energy_chp_combined_cycle_network_gas_steam_hot_water_output_curve', 2)
      create_output_series(el, 'energy_chp_local_engine_biogas_steam_hot_water_output_curve', 'energy_chp_local_engine_biogas_steam_hot_water_output_curve', 3)
      create_output_series(el, 'energy_chp_local_engine_network_gas_steam_hot_water_output_curve', 'energy_chp_local_engine_network_gas_steam_hot_water_output_curve', 4)
      create_output_series(el, 'energy_chp_local_wood_pellets_steam_hot_water_output_curve', 'energy_chp_local_wood_pellets_steam_hot_water_output_curve', 5)
      create_output_series(el, 'energy_chp_supercritical_waste_mix_steam_hot_water_output_curve', 'energy_chp_supercritical_waste_mix_steam_hot_water_output_curve', 6)
      create_output_series(el, 'energy_chp_ultra_supercritical_lignite_steam_hot_water_output_curve', 'energy_chp_ultra_supercritical_lignite_steam_hot_water_output_curve', 7)
      create_output_series(el, 'energy_chp_coal_steam_hot_water_output_curve', 'energy_chps_coal_steam_hot_water_output_curve', 8)
      create_output_series(el, 'energy_heat_backup_burner_network_gas_steam_hot_water_output_curve', 'energy_heat_backup_burner_network_gas_steam_hot_water_output_curve', 9)
      create_output_series(el, 'energy_heat_burner_crude_oil_steam_hot_water_output_curve', 'energy_heat_burner_crude_oil_steam_hot_water_output_curve', 10)
      create_output_series(el, 'energy_heat_burner_coal_steam_hot_water_output_curve', 'energy_heat_burner_coal_steam_hot_water_output_curve', 11)
      create_output_series(el, 'energy_heat_burner_hydrogen_steam_hot_water_output_curve', 'energy_heat_burner_hydrogen_steam_hot_water_output_curve', 12)
      create_output_series(el, 'energy_heat_burner_network_gas_steam_hot_water_output_curve', 'energy_heat_burner_network_gas_steam_hot_water_output_curve', 13)
      create_output_series(el, 'energy_heat_burner_waste_mix_steam_hot_water_output_curve', 'energy_heat_burner_waste_mix_steam_hot_water_output_curve', 14)
      create_output_series(el, 'energy_heat_burner_wood_pellets_steam_hot_water_output_curve', 'energy_heat_burner_wood_pellets_steam_hot_water_output_curve', 15)
      create_output_series(el, 'energy_heat_heatpump_water_water_electricity_steam_hot_water_output_curve', 'energy_heat_heatpump_water_water_electricity_steam_hot_water_output_curve', 16)
      create_output_series(el, 'energy_heat_import_steam_hot_water_steam_hot_water_output_curve', 'energy_heat_import_steam_hot_water_steam_hot_water_output_curve', 17)
      create_output_series(el, 'energy_heat_solar_thermal_steam_hot_water_output_curve', 'energy_heat_solar_thermal_steam_hot_water_output_curve', 18)
      create_output_series(el, 'energy_heat_well_geothermal_steam_hot_water_output_curve', 'energy_heat_well_geothermal_steam_hot_water_output_curve', 19)
      create_output_series(el, 'energy_heat_network_storage_output_curve', 'energy_heat_network_storage_output_curve', 20)
    end
  end

  def down
    ActiveRecord::Base.transaction do
      OutputElement.find_by_key(:heat_network_production).destroy!
    end
  end

  private

  def create_output_series(element, gquery, label, order_by, target_line=false)
    element.output_element_series.create!(output_series_attrs(gquery, label, order_by, target_line))
  end

  def output_series_attrs(gquery, label, order_by, target_line)
      {
        color: COLORS[gquery],
        gquery: gquery,
        is_target_line: target_line,
        label: label,
        order_by: order_by
      }
  end
  end
