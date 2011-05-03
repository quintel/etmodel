class AddSustainableToCarrier < ActiveRecord::Migration
  def self.up
    add_column :carriers, :sustainable, :float
  end

  def self.down
    remove_column :carriers, :sustainable
  end
end
