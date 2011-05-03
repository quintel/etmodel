class AddNumberOfCarsToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :number_of_cars, :float
  end

  def self.down
    remove_column :areas, :number_of_cars
  end
end
