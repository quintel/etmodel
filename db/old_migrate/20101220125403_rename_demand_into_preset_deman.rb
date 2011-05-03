class RenameDemandIntoPresetDeman < ActiveRecord::Migration
  def self.up
    rename_column :converter_datas, :demand, :preset_demand  
    rename_column :converter_datas, :graph_id, :graph_data_id  
    rename_column :converter_datas, :excel_id, :converter_id
  end

  def self.down
    rename_column :converter_datas, :converter_id, :excel_id
    rename_column :converter_datas, :graph_data_id, :graph_id
    rename_column :converter_datas, :preset_demand, :demand
  end
end