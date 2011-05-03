class AddOvernightInvestmentCo2capturePerMjYrToConverters < ActiveRecord::Migration
  def self.up
    add_column :converters, :overnight_investment_co2_capture_per_mj_yr, :float
  end

  def self.down
    remove_column :converters, :overnight_investment_co2_capture_per_mj_yr
  end
end
