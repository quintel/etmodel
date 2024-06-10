class MultiYearChartReadyForCollection < ActiveRecord::Migration[7.1]
  def up
    change_column_null :multi_year_charts, :area_code, true
    change_column_null :multi_year_charts, :end_year, true

    add_column :multi_year_charts, :interpolation, :boolean, default: true
  end

  def down
    change_column_null :multi_year_charts, :end_year, false
    change_column_null :multi_year_charts, :area_code, false

    remove_column :multi_year_charts, :interpolation
  end

end
