class RemoveShortLabelFromSeries < ActiveRecord::Migration
  def self.up
    remove_column :output_element_series, :short_label
  end

  def self.down
    add_column :output_element_series, :new_column_name, :string
  end
end