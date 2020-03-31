class UpdateChart163P2hDistrictHeating < ActiveRecord::Migration[5.2]
  def up
    output_element = OutputElement.find_by_key('use_of_excess_electricity')

    households_p2p = OutputElementSerie.find_by_label('electricity_stored_in_household_batteries')
    households_p2p.update_attribute('color', '#dd33cc')

    transport_p2p = OutputElementSerie.find_by_label('electricity_stored_in_EV')
    transport_p2p.update_attribute('color', '#dd77bb')

    p2g = OutputElementSerie.find_by_label('electricity_converted_to_hydrogen')
    p2g.update_attribute('color', '#dd9977')

    losses = OutputElementSerie.find_by_label('losses_in_storage')
    losses.update_attribute('order_by', '19')

    export = OutputElementSerie.find_by_label('electricity_exported')
    export.update_attribute('order_by', '20')
    export.update_attribute('color', '#77dd99')

    curtailment = OutputElementSerie.find_by_label('electricity_curtailed')
    curtailment.update_attribute('order_by', '21')
    curtailment.update_attribute('color', '#77bbdd')

    OutputElementSerie.create!(
      output_element: output_element,
      label: 'electricity_converted_to_heat_district_heating_heatpump',
      color: '#F6E58D',
      order_by: 9,
      gquery: 'electricity_converted_to_heat_district_heating_heatpump'
    )

    OutputElementSerie.create!(
      output_element: output_element,
      label: 'electricity_converted_to_heat_district_heating_boiler',
      color: '#FFA502',
      order_by: 10,
      gquery: 'electricity_converted_to_heat_district_heating_boiler'
    )

    OutputElementSerie.create!(
      output_element: output_element,
      label: 'electricity_curtailed_solar_pv',
      color: 'blue',
      order_by: 22,
      gquery: 'electricity_curtailed_solar_pv'
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
