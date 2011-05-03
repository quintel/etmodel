class AddAttributesToScenarios < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :number_of_households, :integer
    add_column :scenarios, :number_of_existing_households, :integer
  end

  def self.down
    remove_column :scenarios, :number_of_existing_households
    remove_column :scenarios, :number_of_households
  end
end