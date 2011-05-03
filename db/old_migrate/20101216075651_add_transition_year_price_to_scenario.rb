class AddTransitionYearPriceToScenario < ActiveRecord::Migration
  def self.up           
    add_column :scenarios, :transition_yearprice, :boolean, :default => false
  end

  def self.down
    remove_column :scenarios, :transition_yearprice
  end
end
