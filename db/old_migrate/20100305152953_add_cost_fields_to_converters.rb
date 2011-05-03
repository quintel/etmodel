class AddCostFieldsToConverters < ActiveRecord::Migration
  def self.up
    add_column :converters, :demand_expected_value, :integer, :limit => 8
    add_column :converters, :operational_and_maintenance_cost_expected, :float
    add_column :converters, :fuel_raw_material_expected, :float
    add_column :converters, :fuel_other, :float
    add_column :converters, :cost_of_co2_expected, :float
    add_column :converters, :finance_and_capital_cost_expected, :float
  end

  def self.down
    remove_column :converters, :finance_and_capital_cost_expected
    remove_column :converters, :cost_of_co2_expected
    remove_column :converters, :fuel_other
    remove_column :converters, :fuel_raw_material_expected
    remove_column :converters, :operational_and_maintenance_cost_expected
    remove_column :converters, :demand_expected_value
  end
end
