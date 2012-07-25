class AddOutputElementHiddenFlag < ActiveRecord::Migration
  def self.up
    add_column :output_elements, :hidden, :boolean, :default => false
    add_index :output_elements, :hidden
  end

  def self.down
    remove_column :output_elements, :hidden
  end
end
