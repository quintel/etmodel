class AddDiscardeAtToMultiYearCharts < ActiveRecord::Migration[7.0]
  def change
    add_column :multi_year_charts, :discarded_at, :datetime
    add_index :multi_year_charts, :discarded_at
  end
end
