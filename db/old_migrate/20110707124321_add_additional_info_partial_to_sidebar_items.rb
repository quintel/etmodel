class AddAdditionalInfoPartialToSidebarItems < ActiveRecord::Migration
  def self.up
    add_column :sidebar_items, :additional_info_partial, :string
  end

  def self.down
    remove_column :sidebar_items, :additional_info_partial
  end
end