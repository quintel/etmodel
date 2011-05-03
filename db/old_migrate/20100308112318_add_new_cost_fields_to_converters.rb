class AddNewCostFieldsToConverters < ActiveRecord::Migration
  ATTRIBUTES = %w[
    typical_capacity_gross
    typical_capacity_effective
    typical_thermal_capacity_effective
    max_capacity_factor
    capacity_factor_emperical_scaling_excl
    land_use_in_nl
    technical_lifetime
    technological_maturity
    lead_time
    construction_time
    net_electrical_yield
    net_heat_yield
    co2_production
    cost_operational_and_maintenance_fixed
    cost_operational_and_maintenance_variable_excl_fuel_co2
    cost_co2_capture_excl_fuel
    cost_co2_transport_and_storage
    cost_fuel_other
    cost_fuel_raw_material_expected
    overnight_investment_excl_co2
    overnight_investment_co2_capture
    sustainable
    mainly_baseload
    intermittent
    cost_total_expected
    cost_operational_and_maintenance_expected
    cost_co2_expected
    cost_capital_expected
    cost_finance_and_capital_expected
  ]

  def self.up
    remove_column :converters, :finance_and_capital_cost_expected
    remove_column :converters, :cost_of_co2_expected
    remove_column :converters, :fuel_other
    remove_column :converters, :fuel_raw_material_expected
    remove_column :converters, :operational_and_maintenance_cost_expected


    ATTRIBUTES.each do |attribute_name|
      add_column :converters, attribute_name, :float
    end
  end

  def self.down
    ATTRIBUTES.each do |attribute_name|
      remove_column :converters, attribute_name
    end

    add_column :converters, :operational_and_maintenance_cost_expected, :float
    add_column :converters, :fuel_raw_material_expected, :float
    add_column :converters, :fuel_other, :float
    add_column :converters, :cost_of_co2_expected, :float
    add_column :converters, :finance_and_capital_cost_expected, :float
  end
end
