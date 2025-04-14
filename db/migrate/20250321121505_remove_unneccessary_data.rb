class RemoveUnneccessaryData < ActiveRecord::Migration[7.1]
  def up
    drop_table :users_old
    drop_table :area_dependencies
    drop_table :descriptions
    drop_table :featured_scenarios
    drop_table :multi_year_chart_saved_scenarios
    drop_table :multi_year_chart_scenarios
    drop_table :multi_year_charts
    drop_table :saved_scenario_users
    drop_table :saved_scenarios
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Cannot restore dropped tables"
  end
end
