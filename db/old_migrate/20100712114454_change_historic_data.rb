class ChangeHistoricData < ActiveRecord::Migration
  def self.up
    rename_table :historic_serie_datas, :historic_serie_entries
  end

  def self.down
    rename_table :historic_serie_entries, :historic_serie_datas
  end
end
