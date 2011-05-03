class AddCountryToScenarios < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :country, :string
  end

  def self.down
    remove_column :scenarios, :country
  end
end
