class AddP2hToChart250HourlyHeatProduction < ActiveRecord::Migration[5.2]
  def up
    output_element = OutputElement.find_by_key('heat_network_production')

    OutputElementSerie.create!(
      output_element: output_element,
      label: 'energy_heat_flexibility_p2h_boiler_electricity_steam_hot_water_output_curve',
      color: '#46c1e3',
      order_by: 9,
      gquery: 'energy_heat_flexibility_p2h_boiler_electricity_steam_hot_water_output_curve'
    )

    OutputElementSerie.create!(
      output_element: output_element,
      label: 'energy_heat_flexibility_p2h_heatpump_electricity_steam_hot_water_output_curve',
      color: 'blue',
      order_by: 9,
      gquery: 'energy_heat_flexibility_p2h_heatpump_electricity_steam_hot_water_output_curve'
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
