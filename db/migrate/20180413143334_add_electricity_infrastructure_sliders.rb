class AddElectricityInfrastructureSliders < ActiveRecord::Migration[5.1]
  INPUT_ELEMENTS = [
    ['costs_infrastructure_electricity_lv_net', 1, '€/kW'],
    ['costs_infrastructure_electricity_lv_mv_trafo', 1, '€/kW'],
    ['costs_infrastructure_electricity_mv_net', 1, '€/kW'],
    ['costs_infrastructure_electricity_mv_hv_trafo', 1, '€/kW'],
    ['costs_infrastructure_electricity_hv_net', 1, '€/kW'],
    ['costs_infrastructure_electricity_interconnector_net', 1, '€/kW'],
    ['costs_infrastructure_electricity_offshore_net', 1, '€/kW']
  ]

  def up
    slide = Slide.create!(
      key: 'costs_infrastructure_electricity',
      position: 3,
      sidebar_item: SidebarItem.find_by_key!('infrastructure'),
      output_element: OutputElement.find_by_key!('additional_infrastructure_investments')
    )

    INPUT_ELEMENTS.each.with_index do |(key, step, unit), index|
      InputElement.create!(
        key: key,
        step_value: step,
        unit: unit,
        position: index + 1,
        slide: slide
      )
    end
  end

  def down
    INPUT_ELEMENTS.each do |(key, _)|
      InputElement.find_by_key(key).destroy
    end

    Slide.find_by_key('costs_infrastructure_electricity').destroy
  end
end
