class ChangeConvertersExcelId < ActiveRecord::Migration
  def self.up
    rename_column :converters, :excel_id, :converter_id
  end

  def self.down
    rename_column :converters, :converter_id, :excel_id
  end
end