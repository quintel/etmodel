class RenameGraphIdsInLinksAndTimeCurves < ActiveRecord::Migration
  def self.up
    rename_column :link_datas, :graph_id, :graph_data_id
  end

  def self.down
    rename_column :link_datas, :graph_data_id, :graph_id
  end
end