
#  typical_capacity_gross                                  :float
#  typical_capacity_effective                              :float
#  typical_thermal_capacity_effective                      :float
#  max_capacity_factor                                     :float
#  capacity_factor_emperical_scaling_excl                  :float
#  land_use_in_nl                                          :float
#  technical_lifetime                                      :float
#  technological_maturity                                  :float
#  lead_time                                               :float
#  construction_time                                       :float
#  net_electrical_yield                                    :float
#  net_heat_yield                                          :float
#  co2_production                                          :float
#  cost_operational_and_maintenance_fixed                  :float
#  cost_operational_and_maintenance_variable_excl_fuel_co2 :float
#  cost_co2_capture_excl_fuel                              :float
#  cost_co2_transport_and_storage                          :float
#  cost_fuel_other                                         :float
#  cost_fuel_raw_material_expected                         :float
#  overnight_investment_excl_co2                           :float
#  overnight_investment_co2_capture                        :float
#  sustainable                                             :float
#  mainly_baseload                                         :float
#  intermittent                                            :float
#  cost_total_expected                                     :float
#  cost_operational_and_maintenance_expected               :float
#  cost_co2_expected                                       :float
#  cost_capital_expected                                   :float
#  cost_finance_and_capital_expected                       :float
#  co2_production_kg_per_mj_output                         :float

class ChangeConverterCosts < ActiveRecord::Migration
  def self.up
    remove_column :converters, :co2_production
    rename_column :converters, :typical_capacity_gross, :typical_capacity_gross_in_mj_yr
    rename_column :converters, :typical_capacity_effective, :typical_capacity_effective_in_mj_yr
    rename_column :converters, :typical_thermal_capacity_effective, :typical_thermal_capacity_effective_in_mj_yr
    rename_column :converters, :cost_operational_and_maintenance_expected, :cost_om_expected_per_mj
    rename_column :converters, :cost_operational_and_maintenance_fixed, :cost_om_fixed_per_mj
    rename_column :converters, :cost_operational_and_maintenance_variable_excl_fuel_co2, :cost_om_variable_ex_fuel_co2_per_mj
    rename_column :converters, :cost_co2_capture_excl_fuel, :cost_co2_capture_ex_fuel_per_mj
    rename_column :converters, :cost_co2_transport_and_storage, :cost_co2_transport_and_storage_per_mj
    rename_column :converters, "cost_fuel_other", :cost_fuel_other_per_mj
    rename_column :converters, :overnight_investment_excl_co2, :overnight_investment_ex_co2_per_mj_yr
    rename_column :converters, :overnight_investment_co2_capture, :overnight_investment_co2_capture_per_mj
    rename_column :converters, :cost_total_expected, :cost_total_expected_per_mj
    rename_column :converters, :cost_fuel_raw_material_expected, :cost_fuel_raw_material_expected_per_mj
    rename_column :converters, :cost_co2_expected, :cost_co2_expected_per_mje
    rename_column :converters, :cost_capital_expected, :cost_capital_expected_per_mj
    rename_column :converters, :cost_finance_and_capital_expected, :cost_finance_and_capital_expected_per_mj
    add_column :converters, :installed_capacity_effective, :float
    add_column :converters, :electricitiy_production_actual, :float
  end

  def self.down
    add_column :converters, :co2_production, :float
    remove_column :converters, :electricitiy_production_actual
    remove_column :converters, :installed_capacity_effective

    rename_column :converters, :cost_finance_and_capital_expected_per_mj, :cost_finance_and_capital_expected
    rename_column :converters, :cost_capital_expected_per_mj, :cost_capital_expected
    rename_column :converters, :cost_co2_expected_per_mje, :cost_co2_expected
    rename_column :converters, :cost_fuel_other_per_mj, :cost_fuel_other
    rename_column :converters, :cost_fuel_raw_material_expected_per_mj, :cost_fuel_raw_material_expected
    rename_column :converters, :cost_total_expected_per_mj, :cost_total_expected
    rename_column :converters, :overnight_investment_co2_capture_per_mj, :overnight_investment_co2_capture
    rename_column :converters, :overnight_investment_ex_co2_per_mj_yr, :overnight_investment_excl_co2
    rename_column :converters, :cost_co2_transport_and_storage_per_mj, :cost_co2_transport_and_storage
    rename_column :converters, :cost_co2_capture_ex_fuel_per_mj, :cost_co2_capture_excl_fuel
    rename_column :converters, :cost_om_variable_ex_fuel_co2_per_mj, :cost_operational_and_maintenance_variable_excl_fuel_co2
    rename_column :converters, :cost_om_fixed_per_mj, :cost_operational_and_maintenance_fixed
    rename_column :converters, :cost_om_expected_per_mj, :cost_operational_and_maintenance_expected
    #rename_column :converters, :co2_production_kg_per_mj_output, :co2_production
    rename_column :converters, :typical_thermal_capacity_effective_in_mj_yr, :typical_thermal_capacity_effective
    rename_column :converters, :typical_capacity_effective_in_mj_yr, :typical_capacity_effective
    rename_column :converters, :typical_capacity_gross_in_mj_yr, :typical_capacity_gross
  end
end
