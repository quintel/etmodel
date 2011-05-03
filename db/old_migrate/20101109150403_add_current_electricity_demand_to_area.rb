class AddCurrentElectricityDemandToArea < ActiveRecord::Migration
  def self.up           
    add_column :areas, :current_electricity_demand_in_mj, :bigint, :default => true
  end

  def self.down
    remove_column :areas, :current_electricity_demand_in_mj
  end
end
