class AddHeatNetworkStorageChart < ActiveRecord::Migration[5.2]
  COLORS = {
    'energy_heat_network_storage_storage_curve' => '#E84118',
  }

  def up
     ActiveRecord::Base.transaction do
      el = OutputElement.create!(
        key: :heat_network_storage,
        group: 'Supply',
        output_element_type: OutputElementType.find_by_name(:demand_curve),
        sub_group: 'collective_heat',
        unit: 'MWh'
      )

      create_output_series(el, 'energy_heat_network_storage_storage_curve', 'energy_heat_network_storage_storage_curve', 1)
    end
  end

  def down
    ActiveRecord::Base.transaction do
      OutputElement.find_by_key(:heat_network_storage).destroy!
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
