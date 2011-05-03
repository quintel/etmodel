class AddPercentageOfNewHousesToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :percentage_of_new_houses, :float

  end

  def self.down
    remove_column :areas, :percentage_of_new_houses
  end
end
