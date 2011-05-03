class ChangeConvertersGroupsKey < ActiveRecord::Migration
  def self.up
    rename_column :converters_groups, :blueprint_converter_id, :converter_id
    rename_column :blueprint_converter_positions, :blueprint_converter_id, :converter_id
    rename_column :blueprints_converters, :blueprint_converter_id, :converter_id
    rename_column :slots, :blueprint_converter_id, :converter_id
    rename_column :carrier_datas, :blueprint_carrier_id, :carrier_id
    rename_column :carriers, :blueprint_carrier_id, :carrier_id
    rename_column :links, :blueprint_carrier_id, :carrier_id
    rename_column :slots, :blueprint_carrier_id, :carrier_id
  end

  def self.down
    rename_column :slots, :carrier_id, :blueprint_carrier_id
    rename_column :links, :carrier_id, :blueprint_carrier_id
    rename_column :carriers, :carrier_id, :blueprint_carrier_id
    rename_column :carrier_datas, :carrier_id, :blueprint_carrier_id
    rename_column :slots, :converter_id, :blueprint_converter_id
    rename_column :blueprints_converters, :converter_id, :blueprint_converter_id
    rename_column :blueprint_converter_positions, :converter_id, :blueprint_converter_id
    rename_column :converters_groups, :converter_id, :blueprint_converter_id
  end
end