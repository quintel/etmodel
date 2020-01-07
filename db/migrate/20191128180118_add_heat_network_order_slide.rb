class AddHeatNetworkOrderSlide < ActiveRecord::Migration[5.2]
  KEY = :supply_heat_network_order

  def up
    Slide.create!(
      sidebar_item: SidebarItem.where(key: :heat).first!,
      key: :supply_heat_network_order,
      position: sidebar_item.slides.ordered.last.position + 1,
      output_element: OutputElement.where(
        key: :workflow
      ).first!
    )
  end

  def down
    Slide.where(key: :supply_heat_network_order).first!.destroy!
  end

  private

  def sidebar_item
    SidebarItem.where(key: :heat).first!
  end
end
