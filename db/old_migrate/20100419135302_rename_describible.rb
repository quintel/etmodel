class RenameDescribible < ActiveRecord::Migration
  def self.up
    rename_column :descriptions, :describible_id, :describable_id
    rename_column :descriptions, :describible_type, :describable_type
  end

  def self.down
    rename_column :descriptions, :describable_id, :describible_id
    rename_column :descriptions, :describable_type, :describible_type

  end
end
