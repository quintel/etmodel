class AddHeatPumpCopCutoffSliders < ActiveRecord::Migration[5.0]
  KEYS = %i[
    households_flexibility_space_heating_cop_cutoff
    households_flexibility_water_heating_cop_cutoff
  ]

  def up
    slide = Slide.find_by_key(:flexibility_flexibility_demand_response_hp)

    KEYS.each.with_index do |key, index|
      InputElement.create(
        key: key,
        interface_group: :flexibility_cop,
        step_value: 0.1,
        unit: '#',
        slide: slide,
        position: 2 + index
      )
    end
  end

  def down
    InputElement.where(key: KEYS).destroy_all
  end
end
