class DropOldTables < ActiveRecord::Migration
  def self.up
    drop_table :converters
    #drop_table :carriers
    drop_table :converters_groups
    drop_table :conversions
    drop_table :links
  end

  def self.down
    ActiveRecord::IrreversibleMigration
  end
end
