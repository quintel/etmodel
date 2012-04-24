class AddVimeoIdToTabs < ActiveRecord::Migration
  def self.up
    add_column :tabs, :vimeo_id, :string
  end

  def self.down
    remove_column :tabs, :vimeo_id
  end
end
