class DropOldOutputElementColumns < ActiveRecord::Migration
  def self.up
    remove_column :output_elements, :legend_columns
    remove_column :output_elements, :legend_location
  end

  def self.down
    add_column :output_elements, :legend_columns, :integer
    add_column :output_elements, :legend_location, :string
  end
end
