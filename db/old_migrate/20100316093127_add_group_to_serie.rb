class AddGroupToSerie < ActiveRecord::Migration
  def self.up
    add_column :output_element_series, :group, :string
  end

  def self.down
    remove_column :output_element_series, :group
  end
end
