class AddTargetToOutputElementSerie < ActiveRecord::Migration
  def self.up
    add_column :output_element_series, :is_target, :boolean
    add_column :output_element_series, :position, :string
  end

  def self.down
    remove_column :output_element_series, :is_target
    remove_column :output_element_series, :position
  end
end
