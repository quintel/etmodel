class DropConstraintName < ActiveRecord::Migration
  def self.up
    remove_column :constraints, :name
  end

  def self.down
    add_column :constraints, :name, :string
  end
end
