class RemoveUnusedAttrsFromSidebarItems < ActiveRecord::Migration
  def self.up
    remove_column :sidebar_items, :order_by
    remove_column :sidebar_items, :created_at
    remove_column :sidebar_items, :updated_at
  end

  def self.down
    add_column :sidebar_items, :order_by, :integer
  end
end
