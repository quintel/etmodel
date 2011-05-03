class AddKeyToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :key, :string
  end

  def self.down
    remove_column :groups, :key
  end
end
