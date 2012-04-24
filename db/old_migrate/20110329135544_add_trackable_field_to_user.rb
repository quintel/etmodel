class AddTrackableFieldToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :trackable, :boolean, :default => false
    add_index :users, :trackable
  end

  def self.down
    remove_column :users, :trackable
  end
end
