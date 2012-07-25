class CleanUpInputElements < ActiveRecord::Migration
  def self.up
    remove_column :input_elements, :label
    change_column :input_elements, :input_element_type, :boolean
    rename_column :input_elements, :input_element_type, :fixed

  end

  def self.down
    rename_column :input_elements, :fixed
    change_column :input_elements, :input_element_type, :string
    add_column :input_elements, :label, :string
  end
end