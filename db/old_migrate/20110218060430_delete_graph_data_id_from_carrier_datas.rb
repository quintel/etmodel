class DeleteGraphDataIdFromCarrierDatas < ActiveRecord::Migration
  def self.up
    remove_column :carrier_datas, :graph_data_id
  end

  def self.down
    add_column :carrier_datas, :graph_data_id, :integer
  end
end
