class AddV2AttributesToConverterDatas < ActiveRecord::Migration
  def self.up
    add_column :converter_datas, :typical_input_capacity, :float
    add_column :converter_datas, :fixed_operation_and_maintenance_cost_per_mw_input, :float
    add_column :converter_datas, :residual_value_per_mw_input, :float
    add_column :converter_datas, :decommissioning_costs_per_mw_input, :float
    add_column :converter_datas, :purchase_price_per_mw_input, :float
    add_column :converter_datas, :installing_costs_per_mw_input, :float
  end

  def self.down
    remove_column :converter_datas, :typical_input_capacity
    remove_column :converter_datas, :fixed_operation_and_maintenance_cost_per_mw_input
    remove_column :converter_datas, :residual_value_per_mw_input
    remove_column :converter_datas, :decommissioning_costs_per_mw_input
    remove_column :converter_datas, :purchase_price_per_mw_input
    remove_column :converter_datas, :installing_costs_per_mw_input
  end
end