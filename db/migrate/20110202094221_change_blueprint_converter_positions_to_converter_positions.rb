class ChangeBlueprintConverterPositionsToConverterPositions < ActiveRecord::Migration
  def self.up
    rename_table :blueprint_converter_positions, :converter_positions
  end

  def self.down
    rename_table :converter_positions, :blueprint_converter_positions
  end
end