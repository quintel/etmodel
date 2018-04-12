class AddDynamicDemandSeries < ActiveRecord::Migration[5.1]
  SERIES = [
    [:merit_household_cooking, '#E07033', :merit_household_cooking_demand],
    [:merit_industry_metals, '#000000', :merit_industry_metals_demand],
    [:merit_industry_chemical, '#CCCCCC', :merit_industry_chemical_demand],
    [:merit_household_cooling, '#ADD8E6', :merit_household_cooling_demand],
    [:merit_household_lighting, '#FDE97B', :merit_household_lighting_demand],
    [:merit_household_appliances, '#800080', :merit_household_appliances_demand],
    [:merit_buildings_appliances, '#5D7929', :merit_buildings_appliances_demand],
    [:buildings_cooling_demand, '#92B940', :merit_buildings_cooling_demand],
    [:merit_buildings_lighting, '#006400', :merit_buildings_lighting_demand],
    [:buildings_heating_demand, '#32CD32', :merit_buildings_space_heating_demand],
    [:merit_agriculture, '#854321', :merit_agriculture_demand],
    [:merit_industry_other, '#696969', :merit_industry_other_demand],
    [:merit_transport_other, '#416B86', :merit_transport_other_demand],
    [:other, '#8B0000', :merit_other_demand],
    [:losses_in_storage, '#D87093', :merit_hv_network_loss]
  ]

  def up
    element = OutputElement.find_by_key(:dynamic_demand_curve)

    SERIES.each do |label, color, gquery|
      OutputElementSerie.create!(
        label: label,
        color: color,
        gquery: gquery,
        output_element: element
      )
    end
  end

  def down
    element = OutputElement.find_by_key(:dynamic_demand_curve)

    OutputElementSerie.where(
      output_element_id: element.id,
      label: SERIES.map(&:first)
    ).destroy_all
  end
end
