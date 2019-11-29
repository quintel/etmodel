class AddIndustrialHeatMekko < ActiveRecord::Migration[5.2]


    COLORS = {
      'industry_final_demand_steam_hot_water_in_industrial_heat_network_mekko' => '#A9A9A9',
      'industry_unused_local_production_steam_hot_water_in_industrial_heat_network_mekko' => '#FF8C8C',
      'energy_steel_hisarna_transformation_coal_in_industrial_heat_network_mekko' => '#6AB04C',
      'industry_chp_combined_cycle_gas_power_fuelmix_in_industrial_heat_network_mekko' => '#A4B0BE',
      'industry_chp_engine_gas_power_fuelmix_in_industrial_heat_network_mekko' => '#DFE4EA',
      'industry_chp_turbine_gas_power_fuelmix_in_industrial_heat_network_mekko' => '#F9CA24',
      'industry_chp_ultra_supercritical_coal_in_industrial_heat_network_mekko' => '#485460',
      'industry_chp_wood_pellets_in_industrial_heat_network_mekko' => '#009432',
      'industry_heat_backup_burner_network_gas_in_industrial_heat_network_mekko' => '#CED6E0',
      'industry_heat_burner_coal_in_industrial_heat_network_mekko' => '#333333',
      'industry_heat_burner_crude_oil_in_industrial_heat_network_mekko' => '#CD6133',
      'industry_heat_burner_lignite_in_industrial_heat_network_mekko' => '#e61919',
      'industry_heat_well_geothermal_in_industrial_heat_network_mekko' => '#FFA502'
    }

    def up
       ActiveRecord::Base.transaction do
        el = OutputElement.create!(
          key: :industrial_heat_mekko,
          group: 'Supply',
          output_element_type: OutputElementType.find_by_name(:mekko),
          sub_group: 'heat',
          unit: 'MJ'
        )

        create_output_series(el, 'industry_final_demand_steam_hot_water_in_industrial_heat_network_mekko', 'industry_final_demand_steam_hot_water_in_industrial_heat_network_mekko',1,group: "demand")
        create_output_series(el, 'industry_unused_local_production_steam_hot_water_in_industrial_heat_network_mekko', 'industry_unused_local_production_steam_hot_water_in_industrial_heat_network_mekko',2,group: "demand")
        create_output_series(el, 'energy_steel_hisarna_transformation_coal_in_industrial_heat_network_mekko', 'energy_steel_hisarna_transformation_coal_in_industrial_heat_network_mekko',3,group: "supply")
        create_output_series(el, 'industry_chp_combined_cycle_gas_power_fuelmix_in_industrial_heat_network_mekko', 'industry_chp_combined_cycle_gas_power_fuelmix_in_industrial_heat_network_mekko',4,group: "supply")
        create_output_series(el, 'industry_chp_engine_gas_power_fuelmix_in_industrial_heat_network_mekko', 'industry_chp_engine_gas_power_fuelmix_in_industrial_heat_network_mekko',5,group: "supply")
        create_output_series(el, 'industry_chp_turbine_gas_power_fuelmix_in_industrial_heat_network_mekko', 'industry_chp_turbine_gas_power_fuelmix_in_industrial_heat_network_mekko',6,group: "supply")
        create_output_series(el, 'industry_chp_ultra_supercritical_coal_in_industrial_heat_network_mekko', 'industry_chp_ultra_supercritical_coal_in_industrial_heat_network_mekko',7,group: "supply")
        create_output_series(el, 'industry_chp_wood_pellets_in_industrial_heat_network_mekko', 'industry_chp_wood_pellets_in_industrial_heat_network_mekko',8,group: "supply")
        create_output_series(el, 'industry_heat_backup_burner_network_gas_in_industrial_heat_network_mekko', 'industry_heat_backup_burner_network_gas_in_industrial_heat_network_mekko',9,group: "supply")
        create_output_series(el, 'industry_heat_burner_coal_in_industrial_heat_network_mekko', 'industry_heat_burner_coal_in_industrial_heat_network_mekko',10,group: "supply")
        create_output_series(el, 'industry_heat_burner_crude_oil_in_industrial_heat_network_mekko', 'industry_heat_burner_crude_oil_in_industrial_heat_network_mekko',11,group: "supply")
        create_output_series(el, 'industry_heat_burner_lignite_in_industrial_heat_network_mekko', 'industry_heat_burner_lignite_in_industrial_heat_network_mekko',12,group: "supply")
        create_output_series(el, 'industry_heat_well_geothermal_in_industrial_heat_network_mekko', 'industry_heat_well_geothermal_in_industrial_heat_network_mekko',13,group: "supply")

      end
    end

    def down
      ActiveRecord::Base.transaction do
        OutputElement.find_by_key(:industrial_heat_mekko).destroy!
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
