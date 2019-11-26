class AddNetworkGasStorageChart < ActiveRecord::Migration[5.2]
  COLORS = {
    'network_gas_storage_curve' => '#A4B0BE',
  }

  def up
     ActiveRecord::Base.transaction do
      el = OutputElement.create!(
        key: :network_gas_storage,
        group: 'Supply',
        output_element_type: OutputElementType.find_by_name(:demand_curve),
        sub_group: 'network_gas',
        unit: 'MWh'
      )

      create_output_series(el, 'network_gas_storage_curve', 'network_gas_storage', 1)
    end
  end

  def down
    ActiveRecord::Base.transaction do
      OutputElement.find_by_key(:network_gas_storage).destroy!
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