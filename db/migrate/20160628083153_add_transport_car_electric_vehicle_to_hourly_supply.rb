class AddTransportCarElectricVehicleToHourlySupply < ActiveRecord::Migration
  def change
    output_element = OutputElement.find_by_key('merit_order_hourly_supply')
    output_element_serie = output_element.output_element_series.find_by_label(:transport_car_using_electricity)

    unless output_element_serie
      OutputElementSerie.create!(
        output_element_id: output_element.id,
        label:             'transport_car_using_electricity',
        gquery:            'transport_car_using_electricity',
        color:             '#dd77bb',
        is_target_line:    false,
        order_by:          5,
        group:             'flex'
      )
    end
  end
end
