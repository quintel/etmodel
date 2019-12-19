class AddHeatNetworkDemandChart < ActiveRecord::Migration[5.2]
  COLORS = {
    'heat_network_production_curve' => '#FF0000',
    'agriculture_final_demand_steam_hot_water_input_curve' => '#6AB04C',
    'buildings_final_demand_steam_hot_water_input_curve' => '#F9CA24',
    'households_final_demand_steam_hot_water_input_curve' => '#E69567',
    'other_final_demand_steam_hot_water_input_curve' => '#786FA6',
    'energy_heat_distribution_loss_input_curve' => '#800080',
    'energy_heat_unused_steam_hot_water_input_curve' => '#BFEFFF',
    'energy_heat_network_storage_input_curve' => '#0984E3'
  }

  def up
     ActiveRecord::Base.transaction do
      el = OutputElement.create!(
        key: :heat_network_demand,
        group: 'Supply',
        output_element_type: OutputElementType.find_by_name(:demand_curve),
        sub_group: 'collective_heat',
        unit: 'MW'
      )

      create_output_series(el, 'heat_network_production_curve', 'heat_network_production', 1, target_line=true)
      create_output_series(el, 'agriculture_final_demand_steam_hot_water_input_curve', 'agriculture_final_demand_steam_hot_water_input_curve', 2)
      create_output_series(el, 'buildings_final_demand_steam_hot_water_input_curve', 'buildings_final_demand_steam_hot_water_input_curve', 3)
      create_output_series(el, 'households_final_demand_steam_hot_water_input_curve', 'households_final_demand_steam_hot_water_input_curve', 4)
      create_output_series(el, 'other_final_demand_steam_hot_water_input_curve', 'other_final_demand_steam_hot_water_input_curve', 5)
      create_output_series(el, 'energy_heat_distribution_loss_input_curve', 'energy_heat_distribution_loss_input_curve', 6)
      create_output_series(el, 'energy_heat_unused_steam_hot_water_input_curve', 'energy_heat_unused_steam_hot_water_input_curve', 7)
      create_output_series(el, 'energy_heat_network_storage_input_curve', 'energy_heat_network_storage_input_curve', 8)
    end
  end

  def down
    ActiveRecord::Base.transaction do
      OutputElement.find_by_key(:heat_network_demand).destroy!
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
