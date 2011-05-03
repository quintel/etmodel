class ChangeConverterExcelIdToConverterId < ActiveRecord::Migration
  def self.up
    rename_column :time_curve_entries, :converter_excel_id, :converter_id
  end

  def self.down
    rename_column :time_curve_entries, :converter_id, :converter_excel_id
  end
end