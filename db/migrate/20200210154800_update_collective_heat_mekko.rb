class UpdateCollectiveHeatMekko < ActiveRecord::Migration[5.2]
  def change
    output_element = OutputElement.find_by_key('collective_heat_mekko')

    OutputElementSerie.create!(
      output_element: output_element,
      label: 'energy_heat_industry_residual_heat_in_collective_heat_network_mekko',
      color: '#00008B',
      group: 'supply',
      order_by: 5,
      gquery: 'energy_heat_industry_residual_heat_in_collective_heat_network_mekko'
    )
  end
end
