class AddSidebarParentId < ActiveRecord::Migration
  def up
    add_column :sidebar_items, :parent_id, :integer
    add_index :sidebar_items, :parent_id
    SidebarItem.reset_column_information
    if s = SidebarItem.find_by_key('detailed_industry')
      s.parent_id = SidebarItem.find_by_key('industry').id
      s.key = 'industry_metal'
      s.save
    end
  end

  def down
    remove_column :sidebar_items, :parent_id
  end
end
