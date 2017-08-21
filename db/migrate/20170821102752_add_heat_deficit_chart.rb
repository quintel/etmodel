class AddHeatDeficitChart < ActiveRecord::Migration[5.0]
  COLORS = %w[
    #ffed6f
    #8dd3c7
    #bebada
    #fb8072
    #80b1d3
    #fdb462
    #b3de69
    #fccde5
    #d9d9d9
    #bc80bd
    #ccebc5
  ]

  PRODUCERS = %w[
    households_space_heater_coal
    households_space_heater_combined_network_gas
    households_space_heater_crude_oil
    households_space_heater_district_heating_steam_hot_water
    households_space_heater_electricity
    households_space_heater_heatpump_air_water_electricity
    households_space_heater_heatpump_ground_water_electricity
    households_space_heater_hybrid_heatpump_air_water_electricity
    households_space_heater_micro_chp_network_gas
    households_space_heater_network_gas
    households_space_heater_wood_pellets

    households_water_heater_coal
    households_water_heater_combined_network_gas
    households_water_heater_crude_oil
    households_water_heater_district_heating_steam_hot_water
    households_water_heater_resistive_electricity
    households_water_heater_heatpump_air_water_electricity
    households_water_heater_heatpump_ground_water_electricity
    households_water_heater_hybrid_heatpump_air_water_electricity
    households_water_heater_micro_chp_network_gas
    households_water_heater_network_gas
    households_water_heater_wood_pellets
    households_water_heater_fuel_cell_chp_network_gas
  ]

  def up
    chart = OutputElement.create!(
      key: :heat_deficit,
      group: 'Supply',
      unit: 'PJ',
      requires_merit_order: true,
      output_element_type: OutputElementType.find_by_name(:vertical_stacked_bar)
    )

    PRODUCERS.each.with_index do |producer, index|
      OutputElementSerie.create!(
        output_element: chart,
        gquery: "#{ producer }_deficit",
        color: COLORS[index % COLORS.length],
        label: producer,
        order_by: index + 1
      )
    end
  end

  def down
    OutputElement.find_by_key(:heat_deficit).destroy!
  end
end
