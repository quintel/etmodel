class ChangedVimeoKeysToLocale < ActiveRecord::Migration
  def self.up
    add_column :tabs, :en_vimeo_id, :string
    add_column :sidebar_items, :en_vimeo_id, :string
    rename_column :tabs, :vimeo_id, :nl_vimeo_id
    rename_column :sidebar_items, :vimeo_id, :nl_vimeo_id
  end

  def self.down
    remove_column :tabs, :en_vimeo_id
    remove_column :sidebar_items, :en_vimeo_id
    rename_column :tabs, :nl_vimeo_id, :vimeo_id
    rename_column :sidebar_items, :nl_vimeo_id, :vimeo_id
  end
end
