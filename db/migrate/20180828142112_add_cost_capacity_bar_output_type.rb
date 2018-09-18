class AddCostCapacityBarOutputType < ActiveRecord::Migration[5.1]
  def up
    type = OutputElementType.create!(name: :cost_capacity_bar)

    OutputElement.find_by_key!(:merit_order).update_attributes!(
      output_element_type: type
    )
  end

  def down
    OutputElement.find_by_key!(:merit_order).update_attributes!(
      output_element_type: OutputElementType.find_by_name!(:d3)
    )

    OutputElementType.find_by_name!(:cost_capacity_bar).destroy!
  end
end
