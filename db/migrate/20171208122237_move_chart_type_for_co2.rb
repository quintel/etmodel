class MoveChartTypeForCo2 < ActiveRecord::Migration[5.0]
  def change
    # Update the element type
    output_element = OutputElement.find_by(key: 'co2_emissions_biomass')
    output_element.update_attribute(
      :output_element_type,
      OutputElementType.find_by(name: 'vertical_stacked_bar')
    )

    # Remove the co2_biomass element type
    if el = OutputElementType.find_by(name: 'co2_emissions_biomass')
      el.destroy
    end

    # Changes the co2 1990 element to be a is_1990 serie
    co_nineteen_ninety = output_element
      .output_element_series
      .find_by(label: 'co2_emissions_1990')

    co_nineteen_ninety
      .update_attribute(:is_1990, true)

    # Assign correct target line
    policy_goal_co2_emissions_target_value = output_element
      .output_element_series
      .find_by(gquery: 'policy_goal_co2_emissions_target_value')

    policy_goal_co2_emissions_target_value
      .update_attribute(:is_target_line, true)

    # Remove duplicate serie
    if co2_emission_in_co2_emissions = output_element.output_element_series.find_by(gquery: 'co2_emission_in_co2_emissions')
      co2_emission_in_co2_emissions.destroy
    end

    # Removing series
    old = %w(climate_relevant_co2_biomass_gas_future
             climate_relevant_co2_biomass_liquid_future
             climate_relevant_co2_biomass_solid_future)

    OutputElementSerie.where(gquery: old).destroy_all

    rename = {
      climate_relevant_co2_biomass_solid_present: {
        label: :co2_biomass_solid,
        gquery: :climate_relevant_co2_biomass_solid
      },
      climate_relevant_co2_biomass_liquid_present: {
        label: :co2_biomass_liquid,
        gquery: :climate_relevant_co2_biomass_liquid
      },
      climate_relevant_co2_biomass_gas_present: {
        label: :co2_biomass_gas,
        gquery: :climate_relevant_co2_biomass_gas
      }
    }

    rename.each_pair do |old, n|
      OutputElementSerie.find_by(gquery: old).update_attributes(
        gquery: n[:gquery],
        label:  n[:label]
      )
    end
  end
end
