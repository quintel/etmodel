class ExpandAndUpdateUser < ActiveRecord::Migration
  def self.up
    rename_column :users, :username, :name
    add_column :users, :phone_number, :string
  end

  def self.down
    rename_column :users, :name, :username
    remove_column :users, :phone_number, :string
  end
end
