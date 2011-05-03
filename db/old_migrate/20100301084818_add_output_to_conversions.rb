class AddOutputToConversions < ActiveRecord::Migration
  def self.up
    add_column :conversions, :input, :float
    add_column :conversions, :output, :float
#    remove_column :conversions, :value
  end

  def self.down
#    add_column :conversions, :value, :float
    remove_column :conversions, :output
    remove_column :conversions, :input
  end
end
