class CreateMultiYearChartsSavedScenarios < ActiveRecord::Migration[7.0]
  def change
    create_table :multi_year_chart_saved_scenarios, primary_key: [:multi_year_chart_id, :saved_scenario_id] do |t|
      t.belongs_to :multi_year_chart
      t.belongs_to :saved_scenario
    end
  end
end
