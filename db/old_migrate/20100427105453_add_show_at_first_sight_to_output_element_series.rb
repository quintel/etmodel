class AddShowAtFirstSightToOutputElementSeries < ActiveRecord::Migration
  def self.up
    add_column :output_element_series, :show_at_first, :boolean
  end

  def self.down
    remove_column :output_element_series, :show_at_first
  end
end
