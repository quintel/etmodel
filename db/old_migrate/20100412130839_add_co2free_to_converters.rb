class AddCo2freeToConverters < ActiveRecord::Migration
  def self.up
    add_column :converters, :co2_free, :float
  end

  def self.down
    remove_column :converters, :co2_free
  end
end
