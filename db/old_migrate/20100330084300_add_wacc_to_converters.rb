class AddWaccToConverters < ActiveRecord::Migration
  def self.up
    add_column :converters, :wacc, :float
  end

  def self.down
    remove_column :converters, :wacc
  end
end
