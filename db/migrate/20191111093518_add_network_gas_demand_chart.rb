class AddNetworkGasDemandChart < ActiveRecord::Migration[5.2]
  COLORS = {
    'network_gas_production_curve' => '#FF0000',
    'export_network_gas_input_curve' => '#485460',
    'industry_network_gas_input_curve' => '#416B86',
    'agriculture_network_gas_input_curve' => '#6AB04C',
    'buildings_network_gas_input_curve' => '#F9CA24',
    'households_network_gas_input_curve' => '#E69567',
    'transport_network_gas_input_curve' => '#74B9FF',
    'other_network_gas_input_curve' => '#786FA6',
    'bunkers_network_gas_input_curve' => '#218C74',
    'electricity_production_network_gas_input_curve' => '#0984E3',
    'heat_production_network_gas_input_curve' => '#E84118',
    'hydrogen_production_network_gas_input_curve' => '#87CEEB',
    'energy_network_gas_storage_network_gas_input_curve' => '#DFE4EA'
  }

  def up
     ActiveRecord::Base.transaction do
      el = OutputElement.create!(
        key: :network_gas_demand,
        group: 'Supply',
        output_element_type: OutputElementType.find_by_name(:demand_curve),
        sub_group: 'network_gas',
        unit: 'MW'
      )

      create_output_series(el, 'network_gas_production_curve', 'network_gas_production', 1, target_line=true)
      create_output_series(el, 'export_network_gas_input_curve', 'exported_network_gas', 2)
      create_output_series(el, 'industry_network_gas_input_curve', 'industry_final_demand_network_gas', 3)
      create_output_series(el, 'agriculture_network_gas_input_curve', 'agriculture_final_demand_network_gas', 4)
      create_output_series(el, 'buildings_network_gas_input_curve', 'buildings_final_demand_network_gas', 5)
      create_output_series(el, 'households_network_gas_input_curve', 'households_final_demand_network_gas', 6)
      create_output_series(el, 'transport_network_gas_input_curve', 'transport_final_demand_network_gas', 7)
      create_output_series(el, 'other_network_gas_input_curve', 'other_final_demand_network_gas', 8)
      create_output_series(el, 'bunkers_network_gas_input_curve', 'bunkers_final_demand_network_gas', 9)
      create_output_series(el, 'electricity_production_network_gas_input_curve', 'power_demand_network_gas', 10)
      create_output_series(el, 'heat_production_network_gas_input_curve', 'heat_demand_network_gas', 11)
      create_output_series(el, 'hydrogen_production_network_gas_input_curve', 'hydrogen_demand_network_gas', 12)
      create_output_series(el, 'energy_network_gas_storage_network_gas_input_curve', 'network_gas_storage_input', 13)
    end
  end

  def down
    ActiveRecord::Base.transaction do
      OutputElement.find_by_key(:network_gas_demand).destroy!
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

