class DropOutputElementNameColumn < ActiveRecord::Migration
  def self.up
    remove_column :output_elements, :name
  end

  def self.down
    add_column :output_elements, :name, :string
  end
end
