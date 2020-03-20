class AddHhpCopCostChart < ActiveRecord::Migration[5.2]
  def up
    type = OutputElementType.create!(name: 'hhp_cop_cost')

    chart = OutputElement.create!(
      key: 'household_network_gas_hhp_cop_cost',
      output_element_type: type,
      unit: '€/MJ heat',
      group: 'Cost',
      related_output_element_id: '258'
    )

    OutputElementSerie.create!(
      output_element: chart,
      color: 'green',
      label: 'optimal_threshold',
      gquery: 'household_space_heater_hhp_cost_optimal_threshold_cop',
      order_by: 1
    )

    OutputElementSerie.create!(
      output_element: chart,
      color: '#4169E1',
      label: 'electricity',
      gquery: 'household_space_heater_hhp_network_gas_electricity_cop_costs',
      order_by: 2,
      is_target_line: true
    )

    OutputElementSerie.create!(
      output_element: chart,
      color: '#a4b0be',
      label: 'gas',
      gquery: 'household_space_heater_hhp_network_gas_gas_cop_costs',
      order_by: 3,
      is_target_line: true
    )

  end

  def down
    OutputElement.find_by(key: 'household_network_gas_hhp_cop_cost').destroy!
    OutputElementType.find_by(name: 'hhp_cop_cost').destroy!
  end
end
