class AddColorsForConverterPositions < ActiveRecord::Migration
  def self.up
    add_column :converter_positions, :fill_color, :string unless column_exists?(:converter_positions, :fill_color)
    add_column :converter_positions, :stroke_color, :string unless column_exists?(:converter_positions, :stroke_color)
    Converter.includes(:converter_position, :groups).each do |converter|
      converter_position = converter.converter_position
      converter_position ||= converter.create_converter_position :x => 2000, :y => 2000

      converter_position.assign_colors
      converter_position.save
    end

  end

  def self.down
    remove_column :converter_positions, :stroke_color
    remove_column :converter_positions, :fill_color
  end
end