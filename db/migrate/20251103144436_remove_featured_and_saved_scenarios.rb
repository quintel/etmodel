class RemoveFeaturedAndSavedScenarios < ActiveRecord::Migration[7.1]
  def up
    drop_table :featured_scenarios
    drop_table :saved_scenarios
    drop_table :saved_scenario_users
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
