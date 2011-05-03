class AddRcToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :insulation_level_existing_houses, :float
    add_column :areas, :insulation_level_new_houses, :float
    add_column :areas, :insulation_level_schools, :float
    add_column :areas, :insulation_level_offices, :float
  end

  def self.down
    remove_column :areas, :insulation_level_existing_houses
    remove_column :areas, :insulation_level_new_houses
    remove_column :areas, :insulation_level_schools
    remove_column :areas, :insulation_level_offices
  end
end
