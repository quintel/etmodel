class RenameBlueprintTables < ActiveRecord::Migration
  def self.up
    rename_table :blueprint_converters, :converters
    rename_table :blueprint_carriers, :carriers
    rename_table :blueprint_links, :links
    rename_table :blueprint_slots, :slots 
    rename_table :blueprint_converters_blueprints, :blueprints_converters 
    rename_table :blueprint_converters_groups, :converters_groups
  end

  def self.down
    rename_table :converters_groups, :blueprint_converters_groups
    rename_table :blueprints_converters, :blueprint_converters_blueprints
    rename_table :slots, :blueprint_slots
    rename_table :links, :blueprint_links
    rename_table :carriers, :blueprint_carriers
    rename_table :converters, :blueprint_converters
  end
end