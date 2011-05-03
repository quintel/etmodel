class AddImportElectricyPrimaryDemandFactorToAreas < ActiveRecord::Migration
  def self.up
    add_column :areas, :import_electricity_primary_demand_factor, :float, :default => 1.82
    add_column :areas, :export_electricity_primary_demand_factor, :float, :default => 1.0
  end

  def self.down
    remove_column :areas, :export_electricity_primary_demand_factor
    remove_column :areas, :import_electricity_primary_demand_factor
  end
end
