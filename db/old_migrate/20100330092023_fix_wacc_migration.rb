class FixWaccMigration < ActiveRecord::Migration
  def self.up
    remove_column :converters, :wacc
    add_column :converters, :wacc, :float
  end

  def self.down
  end
end
