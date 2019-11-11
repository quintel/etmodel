class AddNetworkGasSupplyChart < ActiveRecord::Migration[5.2]
  COLORS = {
    'network_gas_demand_curve' => '#FF0000',
    'natural_gas_network_gas_output_curve' => '#A4B0BE',
    'greengas_network_gas_output_curve' => '#92B940',
    'lng_network_gas_output_curve' => '#F6E58D',
    'storage_network_gas_output_curve' => '#DFE4EA'
  }

  def up
     ActiveRecord::Base.transaction do
      el = OutputElement.create!(
        key: :network_gas_production,
        group: 'Supply',
        output_element_type: OutputElementType.find_by_name(:demand_curve),
        sub_group: 'network_gas',
        unit: 'MW'
      )

      create_output_series(el, 'network_gas_demand_curve', 'network_gas_demand', 1, target_line=true)
      create_output_series(el, 'natural_gas_network_gas_output_curve', 'natural_gas_production', 2)
      create_output_series(el, 'greengas_network_gas_output_curve', 'greengas_production', 3)
      create_output_series(el, 'lng_network_gas_output_curve', 'lng_production', 4)
      create_output_series(el, 'storage_network_gas_output_curve', 'network_gas_storage_output', 5)
    end
  end

  def down
    ActiveRecord::Base.transaction do
      OutputElement.find_by_key(:network_gas_production).destroy!
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