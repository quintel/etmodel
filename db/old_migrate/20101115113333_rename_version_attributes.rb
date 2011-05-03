class RenameVersionAttributes < ActiveRecord::Migration

  def self.up
    rename_column :blueprints, :version, :graph_version
  end

  def self.down
    rename_column :blueprints, :graph_version, :version
  end
end