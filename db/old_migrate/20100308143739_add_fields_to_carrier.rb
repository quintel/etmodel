class AddFieldsToCarrier < ActiveRecord::Migration
  def self.up
    add_column :carriers, :cost_per_mj, :float
    add_column :carriers, :co2_per_mj, :float
  end

  def self.down
    remove_column :carriers, :co2_per_mj
    remove_column :carriers, :cost_per_mj
  end
end
