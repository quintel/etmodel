class AddWorkflowOutputElement < ActiveRecord::Migration[5.2]
  def up
    output_element = OutputElement.create!(
      key: 'workflow',
      group: 'Overview',
      hidden: true,
      output_element_type: OutputElementType.find_by_name(:html_table)
    )

    slide = Slide.find_by_key(:introduction_to_etm)
    slide.update_attributes!(output_element: output_element)
  end

  def down
    slide = Slide.find_by_key(:introduction_to_etm)

    slide.update_attributes!(
      output_element: OutputElement.find_by_key(:final_energy_demand_per_sector_joule)
    )

    OutputElement.find_by_key(:workflow).destroy!
  end
end
