class RenameHistoricSerieAreaId < ActiveRecord::Migration
  def self.up
    rename_column :historic_series, :area_id, :area_code
    change_column :historic_series, :area_code, :string
  end

  def self.down
    rename_column :historic_series, :area_code, :area_id
    change_column :historic_series, :area_id, :integer
  end
end
