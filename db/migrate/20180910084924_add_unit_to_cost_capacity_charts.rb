class AddUnitToCostCapacityCharts < ActiveRecord::Migration[5.1]
  def up
    elements.update_all(unit: 'Eur/Mwh')
  end

  def down
    elements.update_all(unit: nil)
  end

  private

  def elements
    OutputElement.where(
      output_element_type: OutputElementType.find_by_name(:cost_capacity_bar)
    )
  end
end
