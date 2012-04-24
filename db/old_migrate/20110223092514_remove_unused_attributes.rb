class RemoveUnusedAttributes < ActiveRecord::Migration
  def self.up
    remove_column :converter_datas, :cost_finance_and_capital_expected_per_mj
    remove_column :converter_datas, :cost_fuel_raw_material_expected_per_mj
    remove_column :converter_datas, :cost_om_expected_per_mj
    remove_column :converter_datas, :cost_total_expected_per_mj
    remove_column :converter_datas, :cost_capital_expected_per_mj
  end

  def self.down
    add_column :converter_datas, :cost_capital_expected_per_mj, :float
    add_column :converter_datas, :cost_total_expected_per_mj, :float
    add_column :converter_datas, :cost_om_expected_per_mj, :float
    add_column :converter_datas, :cost_fuel_raw_material_expected_per_mj, :float
    add_column :converter_datas, :cost_finance_and_capital_expected_per_mj, :float
  end
end
