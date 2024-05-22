class ChangeScenarioHistoryToText < ActiveRecord::Migration[7.0]
  def up
    change_column :saved_scenarios, :scenario_id_history, :text
  end
  def down
    change_column :saved_scenarios, :scenario_id_history, :string
  end
end
