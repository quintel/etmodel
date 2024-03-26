class ChangeDefaultSavedScenarioUserId < ActiveRecord::Migration[7.0]
  def change
    remove_column :saved_scenarios, :user_id
  end
end
