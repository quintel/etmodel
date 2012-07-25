class DropInputElementNameColumn < ActiveRecord::Migration
  def self.up
    remove_column :input_elements, :name
  end

  def self.down
    add_column :input_elements, :name, :string
  end
end
