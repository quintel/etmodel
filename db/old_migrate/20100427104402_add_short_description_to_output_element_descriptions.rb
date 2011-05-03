class AddShortDescriptionToOutputElementDescriptions < ActiveRecord::Migration
  def self.up
    add_column :output_element_series, :short_label, :string
  end

  def self.down
    remove_column :output_element_series, :short_label
  end
end
