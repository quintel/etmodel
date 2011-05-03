class AddLandUseInNlToCarriers < ActiveRecord::Migration
  def self.up
    add_column :carriers, :typical_production_per_km2, :float
  end

  def self.down
    remove_column :carriers, :typical_production_per_km2
  end
end
