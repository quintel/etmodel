class AddMinAndMaxAxisValuesToOutputElement < ActiveRecord::Migration
  def self.up
    add_column :output_elements, :max_axis_value, :float
    add_column :output_elements, :min_axis_value, :float
  end

  def self.down
    remove_column :output_elements, :min_axis_value
    remove_column :output_elements, :max_axis_value
  end
end