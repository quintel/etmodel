class AddP2hToChart248HeatMekko < ActiveRecord::Migration[5.2]
  def up
    output_element = OutputElement.find_by_key('collective_heat_mekko')

    OutputElementSerie.create!(
      output_element: output_element,
      label: 'energy_heat_flexibility_p2h_boiler_electricity_in_collective_heat_network_mekko',
      color: '#46c1e3',
      group: 'supply',
      order_by: 25,
      gquery: 'energy_heat_flexibility_p2h_boiler_electricity_in_collective_heat_network_mekko'
    )

    OutputElementSerie.create!(
      output_element: output_element,
      label: 'energy_heat_flexibility_p2h_heatpump_electricity_in_collective_heat_network_mekko',
      color: 'blue',
      group: 'supply',
      order_by: 26,
      gquery: 'energy_heat_flexibility_p2h_heatpump_electricity_in_collective_heat_network_mekko'
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
