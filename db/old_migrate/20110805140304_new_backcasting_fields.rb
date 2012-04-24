class NewBackcastingFields < ActiveRecord::Migration
  def self.up
    add_column :input_elements, :growth, :boolean
    add_index :input_elements, :growth
    add_column :predictions, :area, :string
    add_index :predictions, :area
  end

  def self.down
    remove_column :input_elements
    remove_column :predictions, :area
  end
end
