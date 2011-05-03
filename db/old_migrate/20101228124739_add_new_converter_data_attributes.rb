class AddNewConverterDataAttributes < ActiveRecord::Migration
  def self.up
    add_column :converter_datas, :typical_electric_capacity, :float
    add_column :converter_datas, :typical_heat_capacity, :float
    add_column :converter_datas, :full_load_hours, :float
    add_column :converter_datas, :operation_hours, :float
    add_column :converter_datas, :operation_and_maintenance_cost_fixed, :float
    add_column :converter_datas, :operation_and_maintenance_cost_variable, :float
    add_column :converter_datas, :investment_excl_ccs, :float
    add_column :converter_datas, :purchase_price, :float
    add_column :converter_datas, :installing_costs, :float
    add_column :converter_datas, :economic_lifetime, :float
    add_column :converter_datas, :ccs_investment, :float
    add_column :converter_datas, :ccs_operation_and_maintenance, :float
  end

  def self.down
    remove_column :converter_datas, :typical_electric_capacity
    remove_column :converter_datas, :typical_heat_capacity
    remove_column :converter_datas, :full_load_hours
    remove_column :converter_datas, :operation_hours
    remove_column :converter_datas, :operation_and_maintenance_cost_fixed
    remove_column :converter_datas, :operation_and_maintenance_cost_variable
    remove_column :converter_datas, :investment_excl_ccs
    remove_column :converter_datas, :purchase_price
    remove_column :converter_datas, :installing_costs
    remove_column :converter_datas, :economic_lifetime
    remove_column :converter_datas, :ccs_investment
    remove_column :converter_datas, :ccs_operation_and_maintenance
  end
end