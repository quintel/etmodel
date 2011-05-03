class AddColumnsToAreas < ActiveRecord::Migration
  def self.up
    add_column :areas, :number_households, :float
    add_column :areas, :number_inhabitants, :float
  end

  def self.down
    remove_column :areas, :number_inhabitants
    remove_column :areas, :number_households
  end
end
