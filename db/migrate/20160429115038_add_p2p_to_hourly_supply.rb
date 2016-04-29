class AddP2pToHourlySupply < ActiveRecord::Migration
  def change
    output_element = OutputElement.find_by_key('merit_order_hourly_supply')

    OutputElementSerie.create!(
      output_element: output_element,
      label: 'households_flexibility_p2p_electricity',
      color: '#92896B',
      group: 'flex',
      gquery: 'households_flexibility_p2p_electricity'
    )
  end
end
