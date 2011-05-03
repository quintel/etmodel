class AddHasBuildingsToArea < ActiveRecord::Migration
  def self.up           
    add_column :areas, :has_buildings, :boolean
  end

  def self.down
    remove_column :areas, :has_buildings
  end
end
