class AddUniqueIndexToConversions < ActiveRecord::Migration
  def self.up
    add_index :conversions, [:converter_id, :carrier_id], :unique => true
  end

  def self.down
    remove_index :conversions, :column => [:converter_id, :carrier_id]
  end
end
