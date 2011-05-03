class AddInifiniteToCarriers < ActiveRecord::Migration
  def self.up
    add_column :carriers, :infinite, :float
  end

  def self.down
    remove_column :carriers, :infinite
  end
end
