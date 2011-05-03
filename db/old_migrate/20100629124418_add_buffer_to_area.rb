class AddBufferToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :capacity_buffer_in_mj_s, :float
  end

  def self.down
    remove_column :areas, :capacity_buffer_in_mj_s
  end
end
