class ChangeGraphDataIdToDatasetId < ActiveRecord::Migration
  def self.up
    rename_table :graph_datas, :datasets
    rename_column :link_datas, :graph_data_id, :dataset_id
    rename_column :converter_datas, :graph_data_id, :dataset_id
    rename_column :slot_datas, :graph_data_id, :dataset_id
    rename_column :user_graphs, :graph_data_id, :dataset_id
  end

  def self.down
    rename_table :datasets, :graph_datas
    rename_column :user_graphs, :dataset_id, :graph_data_id
    rename_column :slot_datas, :dataset_id, :graph_data_id
    rename_column :converter_datas, :dataset_id, :graph_data_id
    rename_column :link_datas, :dataset_id, :graph_data_id
  end
end