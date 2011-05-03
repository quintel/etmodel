class RemoveUnusedColumns < ActiveRecord::Migration
  def self.up
    remove_column :carriers, :blueprint_id
    remove_column :areas, :title
    drop_table :csv_import_helper
    drop_table :sessions
  end

  def self.down
  end
end
