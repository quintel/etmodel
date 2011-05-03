class RenameBlueprintCarrierrExcelId < ActiveRecord::Migration
  def self.up
    rename_column :blueprint_carriers, :excel_id, :blueprint_carrier_id
  end

  def self.down
    rename_column :blueprint_carriers, :blueprint_carrier_id, :excel_id
  end
end