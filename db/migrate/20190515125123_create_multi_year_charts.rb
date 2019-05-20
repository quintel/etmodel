class CreateMultiYearCharts < ActiveRecord::Migration[5.2]
  def change
    create_table :multi_year_charts do |t|
      t.belongs_to :user, null: false

      t.string :title, null: false
      t.string :area_code, null: false
      t.integer :end_year, null: false

      t.datetime :created_at, null: false
    end

    create_table :multi_year_chart_scenarios do |t|
      t.belongs_to :multi_year_chart, null: false
      t.integer :scenario_id, null: false
    end

    add_index :multi_year_chart_scenarios, :scenario_id
  end
end
