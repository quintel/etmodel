class AddP2hDistrictHeatingToChart173 < ActiveRecord::Migration[5.2]
  def up
    output_element = OutputElement.find_by_key('merit_order_hourly_flexibility')

    export = OutputElementSerie.find_by_label('energy_export_electricity')
    export.update_attribute('order_by', '20')

    curtailment = OutputElementSerie.find_by_label('energy_flexibility_curtailment_electricity')
    curtailment.update_attribute('order_by', '21')

    OutputElementSerie.create!(
      output_element: output_element,
      label: 'energy_heat_flexibility_p2h_heatpump_electricity',
      color: '#F6E58D',
      order_by: 9,
      gquery: 'energy_heat_flexibility_p2h_heatpump_electricity'
    )

    OutputElementSerie.create!(
      output_element: output_element,
      label: 'energy_heat_flexibility_p2h_boiler_electricity',
      color: '#FFA502',
      order_by: 10,
      gquery: 'energy_heat_flexibility_p2h_boiler_electricity'
    )

    OutputElementSerie.create!(
      output_element: output_element,
      label: 'solar_pv_total_curtailed_electricity_curve',
      color: 'blue',
      order_by: 22,
      gquery: 'solar_pv_total_curtailed_electricity_curve'
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
