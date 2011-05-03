class AddSolarSurfacteToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :land_available_for_solar, :float
  end

  def self.down
    remove_column  :areas, :land_available_for_solar
  end
end
