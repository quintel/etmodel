class AddGasNetCostToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :annual_infrastructure_cost_gas, :float
    rename_column :areas, :annual_infrastructure_cost, :annual_infrastructure_cost_electricity
  end

  def self.down
    remove :areas, :annual_infrastructure_cost_gas
    rename_column :areas, :annual_infrastructure_cost_electricity, :annual_infrastructure_cost
  end
end
