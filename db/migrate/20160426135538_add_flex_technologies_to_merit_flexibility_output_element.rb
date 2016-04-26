class AddFlexTechnologiesToMeritFlexibilityOutputElement < ActiveRecord::Migration
  def change
    output_element = OutputElement.find_or_create_by!(
      key: 'merit_order_hourly_flexibility',
      output_element_type_id: 16,
      unit: "MW",
      group: "Merit",
      requires_merit_order: true
    )

    colors = ["#bbdd77", "#dd77bb", "#dd9977", "#bbdd77", "#77dd99", "#77bbdd"]

    output_elements = OutputElementSerie.where(group: 'flex')
    output_elements.update_all(output_element_id: output_element.id)

    output_elements.each_with_index do |el, index|
      el.update_attribute(:color, colors[index])
    end

    OutputElementSerie.create!(
      label: 'total_demand',
      color: '#CC0000',
      is_target_line: true,
      gquery: 'total_demand',
      output_element: output_element
    )
  end
end
