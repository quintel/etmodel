class AddCapacityFactorToConverters < ActiveRecord::Migration
  def self.up
    add_column :converters, :capacity_factor, :float
  end

  def self.down
    remove_column :converters, :capacity_factor
  end
end
