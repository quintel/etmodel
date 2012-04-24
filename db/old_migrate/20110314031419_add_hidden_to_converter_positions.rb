class AddHiddenToConverterPositions < ActiveRecord::Migration
  def self.up
    add_column :converter_positions, :hidden, :boolean
  end

  def self.down
    remove_column :converter_positions, :hidden
  end
end
