class AddBuildingsHeatChart < ActiveRecord::Migration[5.1]
  def up
    oe = OutputElement.create!(
      unit: 'MW',
      group: 'Merit',
      sub_group: 'merit_order',
      key: 'buildings_heat_demand_and_production',
      output_element_type: OutputElementType.find_by_name('heat_demand_and_production'),
      requires_merit_order: true
    )

    oe.output_element_series.create!(
      label: 'demand',
      color: '#FF0000',
      order_by: 1,
      is_target_line: 1,
      gquery: 'hourly_buildings_heat_demand'
    )

    oe.output_element_series.create!(
      label: 'production',
      color: '#FDE97B',
      order_by: 2,
      gquery: 'hourly_buildings_heat_production'
    )
  end

  def down
    OutputElement.find_by_key('buildings_heat_demand_and_production').destroy
  end
end
