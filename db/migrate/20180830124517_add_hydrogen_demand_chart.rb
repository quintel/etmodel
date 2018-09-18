class AddHydrogenDemandChart < ActiveRecord::Migration[5.1]
  def up
    chart = OutputElement.create!(
      key: :hydrogen_demand,
      output_element_type: OutputElementType.find_by_name(:demand_curve),
      unit: 'MW',
      group: 'Supply',
      sub_group: 'hydrogen',
      requires_merit_order: true
    )

    series = {
      agriculture_final_demand_hydrogen: ['#098c48'],
      buildings_collective_burner_hydrogen: ['#D87093'],
      energy_export_hydrogen: ['#333333', 'exported_hydrogen'],
      energy_hydrogen_storage: ['#A2D679', 'hydrogen_storage'],
      energy_power_turbine_hydrogen: ['#87CEEB'],
      households_collective_burner_hydrogen: ['#8B0000'],
      industry_final_demand_hydrogen: ['#7F4b9E'],
      industry_final_demand_hydrogen_non_energetic: ['#00008B'],
      transport_final_demand_hydrogen: ['#E07033']
    }

    series.each.with_index do |(key, (color, label)), index|
      chart.output_element_series.create!(
        gquery: "#{key}_hydrogen_input_curve",
        label: label || key,
        order_by: index + 1,
        color: color
      )
    end
  end

  def down
    OutputElement.find_by_key(:hydrogen_demand).destroy
  end
end
