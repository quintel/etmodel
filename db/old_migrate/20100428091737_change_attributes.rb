class ChangeAttributes < ActiveRecord::Migration
  def self.up
    rename_column :converters, :typical_capacity_gross_in_mj_yr, :typical_capacity_gross_in_mj_s
    rename_column :converters, :typical_capacity_effective_in_mj_yr, :typical_capacity_effective_in_mj_s
    rename_column :converters, :overnight_investment_ex_co2_per_mj_yr, :overnight_investment_ex_co2_per_mj_s
    rename_column :converters, :overnight_investment_co2_capture_per_mj_yr, :overnight_investment_co2_capture_per_mj_s
    rename_column :converters, :installed_capacity_effective, :installed_capacity_effective_in_mj_s
  end

  def self.down
    rename_column :converters, :installed_capacity_effective_in_mj_s, :installed_capacity_effective
    rename_column :converters, :overnight_investment_co2_capture_per_mj_, :overnight_investment_co2_capture_per_mj_yr
    rename_column :converters, :overnight_investment_ex_co2_per_mj_s, :overnight_investment_ex_co2_per_mj_yr
    rename_column :converters, :typical_capacity_effective_in_mj_s, :typical_capacity_effective_in_mj_yr
    rename_column :converters, :typical_capacity_gross_in_mj_s, :typical_capacity_gross_in_mj_yr
  end
end
