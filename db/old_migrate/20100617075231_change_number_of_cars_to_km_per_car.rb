class ChangeNumberOfCarsToKmPerCar < ActiveRecord::Migration
  def self.up
    rename_column :areas, :number_of_cars, :km_per_car
  end

  def self.down
    rename_column :areas, :km_per_car, :number_of_cars
  end
end
