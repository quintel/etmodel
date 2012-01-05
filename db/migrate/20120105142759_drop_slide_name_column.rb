class DropSlideNameColumn < ActiveRecord::Migration
  def self.up
    remove_column :slides, :name
  end

  def self.down
    add_column :slides, :name, :string
  end
end
