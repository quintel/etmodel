class ChangeTransitionYearPriceToScenarioType < ActiveRecord::Migration
  def self.up
    remove_column :scenarios, :transition_yearprice
    add_column :scenarios, :scenario_type, :string
  end

  def self.down
  end
end
