class AddMvSpaceHeatingCurves < ActiveRecord::Migration[5.1]
  def up
    OutputElementSerie.create!(
      output_element: output_element,
      label: :mv_buildings_space_heating,
      gquery: :mv_buildings_space_heating_load_curve,
      color: '#4A3609'
    )

    OutputElementSerie.create!(
      output_element: output_element,
      label: :mv_households_space_heating,
      gquery: :mv_households_space_heating_load_curve,
      color: '#E83B35'
    )
  end

  def down
    output_element.output_element_series
      .find_by_gquery!(:mv_buildings_space_heating_load_curve)
      .destroy!

    output_element.output_element_series
      .find_by_gquery!(:mv_households_space_heating_load_curve)
      .destroy!
  end

  private

  def output_element
    OutputElement.find_by_key!(:mv_demand_curves)
  end
end
