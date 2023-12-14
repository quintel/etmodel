class AddCurrentSavedScenarioVersionToSavedScenarios < ActiveRecord::Migration[7.0]
  def change
    add_column :saved_scenarios, :saved_scenario_version_id, :integer
  end
end
