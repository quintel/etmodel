class AddTrucksKmAndDecentralBufferToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :capacity_buffer_decentral_in_mj_s, :float
    add_column :areas, :km_per_truck, :float
  end

  def self.down
    remove_column :areas, :capacity_buffer_decentral_in_mj_s
    remove_column :areas, :km_per_truck
  end
end
