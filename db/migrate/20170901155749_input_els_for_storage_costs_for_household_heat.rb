class InputElsForStorageCostsForHouseholdHeat < ActiveRecord::Migration[5.0]
  INPUTS = %i[
    investment_costs_households_storage_space_heating
    investment_costs_households_storage_water_heating
  ]

  def up
    slide = Slide.find_by_key(:costs_heating_technologies_investment)

    INPUTS.each.with_index do |key, index|
      InputElement.create!(
        key: key,
        step_value: 1,
        unit: '€/kWh',
        position: index + 1,
        interface_group: 'heat_buffer_costs',
        slide: slide
      )
    end
  end

  def down
    InputElement.where(key: INPUTS).destroy_all
  end
end
