class AddInputElementTypeToInputElements < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :input_element_type, :string
  end

  def self.down
    remove_column :input_elements, :input_element_type
  end
end
