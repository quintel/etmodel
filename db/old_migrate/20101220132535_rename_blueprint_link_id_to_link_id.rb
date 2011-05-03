class RenameBlueprintLinkIdToLinkId < ActiveRecord::Migration
  def self.up
    rename_column :link_datas, :blueprint_link_id, :link_id
  end

  def self.down
    rename_column :link_datas, :link_id, :blueprint_link_id
  end
end