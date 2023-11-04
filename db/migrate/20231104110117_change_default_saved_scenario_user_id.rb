class ChangeDefaultSavedScenarioUserId < ActiveRecord::Migration[7.0]
  def change
    change_column_null :saved_scenarios, :user_id, true, nil
  end
end
