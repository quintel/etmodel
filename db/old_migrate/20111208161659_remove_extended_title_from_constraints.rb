class RemoveExtendedTitleFromConstraints < ActiveRecord::Migration
  def self.up
    remove_column :constraints, :extended_title
  end

  def self.down
    add_column :constraints, :extended_title, :string
  end
end
