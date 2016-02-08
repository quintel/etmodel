class RemoveChartNumberFromConstraints < ActiveRecord::Migration
  def change
    remove_column :constraints, :chart_number
  end
end
