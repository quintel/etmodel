class AddScenarioIdHistoryToSavedScenarios < ActiveRecord::Migration[5.2]
  def change
    add_column :saved_scenarios, :scenario_id_history, :string, after: :scenario_id
  end
end
