class AddHeatCostCapacityChart < ActiveRecord::Migration[5.2]

  COLORS = {
    'energy_heat_backup_burner_network_gas_heat_cost_capacity_chart' => '#CED6E0',
    'energy_heat_burner_coal_heat_cost_capacity_chart' => '#333333',
    'energy_heat_burner_crude_oil_heat_cost_capacity_chart' => '#CD6133',
    'energy_heat_burner_hydrogen_heat_cost_capacity_chart' => '#87CEEB',
    'energy_heat_burner_network_gas_heat_cost_capacity_chart' => '#A4B0BE',
    'energy_heat_burner_waste_mix_heat_cost_capacity_chart' => '#006266',
    'energy_heat_burner_wood_pellets_heat_cost_capacity_chart' => '#009432',
    'energy_heat_heatpump_water_water_electricity_heat_cost_capacity_chart' => '#ADD8E6',
    'energy_heat_network_storage_heat_cost_capacity_chart' => '#0984E3'
  }

  def up
     ActiveRecord::Base.transaction do
      el = OutputElement.create!(
        key: :heat_cost_capacity,
        group: 'Supply',
        output_element_type: OutputElementType.find_by_name(:cost_capacity_bar),
        sub_group: 'collective_heat',
        unit: 'Eur/MWh',
        requires_merit_order: true
      )

      create_output_series(el, 'energy_heat_backup_burner_network_gas_heat_cost_capacity_chart', 'energy_heat_backup_burner_network_gas', 1)
      create_output_series(el, 'energy_heat_burner_coal_heat_cost_capacity_chart', 'energy_heat_burner_coal', 1)
      create_output_series(el, 'energy_heat_burner_crude_oil_heat_cost_capacity_chart', 'energy_heat_burner_crude_oil', 1)
      create_output_series(el, 'energy_heat_burner_hydrogen_heat_cost_capacity_chart', 'energy_heat_burner_hydrogen', 1)
      create_output_series(el, 'energy_heat_burner_network_gas_heat_cost_capacity_chart', 'energy_heat_burner_network_gas', 1)
      create_output_series(el, 'energy_heat_burner_waste_mix_heat_cost_capacity_chart', 'energy_heat_burner_waste_mix', 1)
      create_output_series(el, 'energy_heat_burner_wood_pellets_heat_cost_capacity_chart', 'energy_heat_burner_wood_pellets', 1)
      create_output_series(el, 'energy_heat_heatpump_water_water_electricity_heat_cost_capacity_chart', 'energy_heat_heatpump_water_water_electricity', 1)
      create_output_series(el, 'energy_heat_network_storage_heat_cost_capacity_chart', 'energy_heat_network_storage', 1)
    end
  end

  def down
    ActiveRecord::Base.transaction do
      OutputElement.find_by_key(:heat_cost_capacity).destroy!
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
