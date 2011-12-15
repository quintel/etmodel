class DropSidebarItemNameColumn < ActiveRecord::Migration
  def self.up
    remove_column :sidebar_items, :name
  end

  def self.down
    add_column :sidebar_items, :name, :string
  end
end
