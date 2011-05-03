class AddCostlineNetworkAndMountainsToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :use_network_calculations, :boolean
    add_column :areas, :has_coastline, :boolean
    add_column :areas, :has_mountains, :boolean
  end

  def self.down
    remove :areas, :use_network_calculations
    remove :areas, :has_mountains
    remove :areas, :has_coastline
  end
end
