class RemoveInfoPartialFormSidebar < ActiveRecord::Migration
  def self.up
    remove_column :sidebar_items, :additional_info_partial
  end

  def self.down
    add_column :sidebar_items, :additional_info_partial, :string
  end
end
