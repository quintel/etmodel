class AddResidualHeatToChart250 < ActiveRecord::Migration[5.2]
  def change
    output_element = OutputElement.find_by_key('heat_network_production')

    OutputElementSerie.create!(
      output_element: output_element,
      label: 'energy_heat_industry_residual_heat_steam_hot_water_output_curve',
      color: '#00008B',
      order_by: 1,
      gquery: 'energy_heat_industry_residual_heat_steam_hot_water_output_curve'
    )
  end
end
