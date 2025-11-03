class RemoveMultiYearCharts < ActiveRecord::Migration[7.1]
  def up
    drop_table :multi_year_charts
    drop_table :multi_year_chart_saved_scenarios
    drop_table :multi_year_chart_scenarios
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
