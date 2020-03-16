class AddChartHhpHourlyDemand < ActiveRecord::Migration[5.2]
  def up
    type = OutputElementType.create!(name: 'demand_curve')

    chart = OutputElement.create!(
      key: 'household_space_heater_hhp_hourly_demand',
      output_element_type: type,
      unit: 'MW',
      group: 'Demand',
      sub_group: 'households'
    )

    OutputElementSerie.create!(
      output_element: chart,
      color: '#a4b0be',
      label: 'gas',
      gquery: 'households_space_heater_hybrid_heatpump_network_gas_input_curve',
      order_by: 1
    )

    OutputElementSerie.create!(
      output_element: chart,
      color: '#ffa500',
      label: 'electricity',
      gquery: 'households_space_heater_hybrid_heatpump_electricity_input_curve',
      order_by: 2
    )

  end

  def down
    OutputElement.find_by(key: 'household_space_heater_hhp_hourly_demand').destroy!
  end
end
