class AddPeakLoadUnitsPresentToConverters < ActiveRecord::Migration
  def self.up
    add_column :converters, :peak_load_units_present, :float
  end

  def self.down
    remove_column :converters, :peak_load_units_present
  end
end
