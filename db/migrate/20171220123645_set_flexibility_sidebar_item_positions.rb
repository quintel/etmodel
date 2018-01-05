class SetFlexibilitySidebarItemPositions < ActiveRecord::Migration[5.0]
  def up
    keys  = %w[flexibility_storage flexibility_conversion flexibility_demand]
    items = SidebarItem.where(key: keys)

    items.each.with_index do |item, index|
      item.update_attributes!(position: keys.index(item.key) + 1)
    end
  end

  def down
    # noop
  end
end
