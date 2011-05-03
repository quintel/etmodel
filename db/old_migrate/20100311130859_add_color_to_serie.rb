class AddColorToSerie < ActiveRecord::Migration
  def self.up
    add_column :output_element_series, :color, :string
  end

  def self.down
    remove_column :output_element_series, :color
  end
end
