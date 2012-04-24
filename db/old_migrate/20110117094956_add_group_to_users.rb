class AddGroupToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :group, :string
  end

  def self.down
    remove_column :users, :group
  end
end