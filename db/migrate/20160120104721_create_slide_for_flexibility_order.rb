class CreateSlideForFlexibilityOrder < ActiveRecord::Migration
  def change
    sidebar_item = SidebarItem.find_by_key("electricity_storage")
    output_element = OutputElement.find_by_key("energy_storage")
    Slide.create!(
      position: 7,
      key: 'flexibility_order',
      sidebar_item_id: sidebar_item.id,
      output_element_id: output_element.id,
      alt_output_element_id: output_element.id
    )
  end
end
