class AddHydrogenStorageChart < ActiveRecord::Migration[5.1]
  def up
    chart = OutputElement.create!(
      key: :hydrogen_storage,
      output_element_type: OutputElementType.find_by_name(:demand_curve),
      unit: 'MWh',
      group: 'Supply',
      sub_group: 'hydrogen',
      requires_merit_order: true
    )

    chart.output_element_series.create!(
      gquery: :energy_hydrogen_storage_storage_curve,
      label: :hydrogen_storage,
      order_by: 1,
      color: '#A2D679'
    )
  end

  def down
    OutputElement.find_by_key!(:hydrogen_storage).destroy!
  end
end
