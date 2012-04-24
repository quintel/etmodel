class AddVimeoToSidebar < ActiveRecord::Migration
  def self.up
    add_column :sidebar_items, :vimeo_id, :string
  end

  def self.down
    remove_column :sidebar_items, :vimeo_id
  end
end