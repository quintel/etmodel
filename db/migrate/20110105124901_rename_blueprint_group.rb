class RenameBlueprintGroup < ActiveRecord::Migration
  def self.up
     rename_column :groups, :blueprint_group_id, :group_id
  end

  def self.down
     rename_column :groups, :group_id, :blueprint_group_id
  end
end
