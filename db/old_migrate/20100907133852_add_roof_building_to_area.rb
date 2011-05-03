class AddRoofBuildingToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :roof_surface_available_pv_buildings, :float
  end

  def self.down
    remove_column :areas, :roof_surface_available_pv_buildings
  end
end
