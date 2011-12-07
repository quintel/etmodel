class AddAssociatedConverterToSlider < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :related_converter, :string
  end

  def self.down
    remove_column :input_elements, :related_converter
  end
end
