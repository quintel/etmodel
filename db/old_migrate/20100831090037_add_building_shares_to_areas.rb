class AddBuildingSharesToAreas < ActiveRecord::Migration
  def self.up
    add_column :areas, :buildings_heating_share_offices, :float
    add_column :areas, :buildings_heating_share_schools, :float
    add_column :areas, :buildings_heating_share_other, :float
  end

  def self.down
    remove_column :areas, :buildings_heating_share_offices
    remove_column :areas, :buildings_heating_share_schools
    remove_column :areas, :buildings_heating_share_other
  end
end
