class RemoveSavedScenarioSettings < ActiveRecord::Migration[7.0]
  def change
    # This attribute has been deprectaed and unused for years, let's remove it
    remove_column :saved_scenarios, :settings
  end
end
