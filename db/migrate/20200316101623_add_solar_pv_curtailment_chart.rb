class AddSolarPvCurtailmentChart < ActiveRecord::Migration[5.2]
  def up
    type = OutputElementType.create!(name: 'solar_curtailment')

    chart = OutputElement.create!(
      key: 'hourly_solar_pv_curtailment',
      output_element_type: type,
      unit: 'MW',
      group: 'Merit',
      sub_group: 'flexibility',
    )

    OutputElementSerie.create!(
      output_element: chart,
      color: 'lightgreen',
      label: 'energy_power_solar_pv_electricity_output_curve',
      gquery: 'energy_power_solar_pv_electricity_output_curve',
      order_by: 1
    )

    OutputElementSerie.create!(
      output_element: chart,
      color: '#32a852',
      label: 'buildings_solar_pv_electricity_output_curve',
      gquery: 'buildings_solar_pv_electricity_output_curve',
      order_by: 1,
    )

    OutputElementSerie.create!(
      output_element: chart,
      color: 'green',
      label: 'households_solar_pv_electricity_output_curve',
      gquery: 'households_solar_pv_electricity_output_curve',
      order_by: 1,
    )

    OutputElementSerie.create!(
      output_element: chart,
      color: 'skyblue',
      label: 'energy_power_solar_pv_curtailed_electricity_output_curve',
      gquery: 'energy_power_solar_pv_curtailed_electricity_output_curve',
      order_by: 2,
    )

    OutputElementSerie.create!(
      output_element: chart,
      color: '#46c1e3',
      label: 'buildings_solar_pv_curtailed_electricity_output_curve',
      gquery: 'buildings_solar_pv_curtailed_electricity_output_curve',
      order_by: 2,
    )

    OutputElementSerie.create!(
      output_element: chart,
      color: 'blue',
      label: 'households_solar_pv_curtailed_electricity_output_curve',
      gquery: 'households_solar_pv_curtailed_electricity_output_curve',
      order_by: 2,
    )
  end

  def down
    OutputElement.find_by(key: 'hourly_solar_pv_curtailment').destroy!
    OutputElementType.find_by(name: 'solar_curtailment').destroy!
  end
end
