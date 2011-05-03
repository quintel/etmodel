class AddEndYearToScenario < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :end_year, :integer, :default => 2040
  end

  def self.down
    remove_column :scenarios, :end_year
  end
end
