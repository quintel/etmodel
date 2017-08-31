class AddHeatDemandAndProductionChart < ActiveRecord::Migration[5.0]
  def up
    type = OutputElementType.create!(name: 'heat_demand_and_production')

    element = OutputElement.create!(
      output_element_type: type,
      unit: 'MW',
      group: 'Merit',
      key: 'household_heat_demand_and_production',
      requires_merit_order: true
    )

    OutputElementSerie.create!(
      output_element: element,
      label: 'demand',
      color: '#FF0000',
      order_by: 1,
      is_target_line: true,
      gquery: 'hourly_household_heat_demand'
    )

    OutputElementSerie.create!(
      output_element: element,
      label: 'production',
      color: '#FDE97B',
      order_by: 2,
      gquery: 'hourly_household_heat_production'
    )
  end

  def down
    OutputElement.find_by_key('household_heat_demand_and_production').destroy!
    OutputElementType.find_by_name('heat_demand_and_production').destroy!
  end
end
