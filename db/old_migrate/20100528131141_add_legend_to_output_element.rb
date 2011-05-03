class AddLegendToOutputElement < ActiveRecord::Migration
  def self.up
    add_column :output_elements, :legend_columns, :integer
    add_column :output_elements, :legend_location, :string
    add_column :output_elements, :unit, :string
    add_column :output_elements, :percentage, :boolean
  end

  def self.down
    remove_column :output_elements, :legend_columns
    remove_column :output_elements, :legend_location
    remove_column :output_elements, :unit
    remove_column :output_elements, :percentage
  end
end
