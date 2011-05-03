class AddKeyToCarriers < ActiveRecord::Migration
  def self.up
    add_column :carriers, :key, :string
  end

  def self.down
    remove_column :carriers, :key
  end
end
