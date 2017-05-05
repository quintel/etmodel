class CreateOutputElementForEvProfiles < ActiveRecord::Migration[5.0]
  def change
    output_element = OutputElement.create!(
      output_element_type_id: 16,
      group: '',
      key: 'dynamic_demand_curve',
      unit: 'MW',
      group: "Merit"
    )

    colors = [
      "#8c5e5e", "#eaee4e", "#64edde", "#ee841a", "#ed9bee",
      "#7bc2eb", "#819a47", "#ee526a", "#a7ed8e", "#62988e",
      "#c59e04", "#a76426", "#a182b8", "#d25e92", "#55e4e8"
    ]

    %w(
      merit_ev_demand
      merit_household_hot_water_demand
      merit_new_household_space_heating_demand
      merit_old_household_space_heating_demand
    ).each_with_index do |query, i|
      OutputElementSerie.create!(
        label: query,
        color: colors[i],
        gquery: query,
        output_element: output_element
      )
    end

    OutputElementSerie.create!(
      label: 'total_demand',
      color: "#CC0000",
      gquery: 'total_demand',
      output_element: output_element,
      is_target_line: true
    )
  end
end
