class RemoveInfinitFromCarrierDatas < ActiveRecord::Migration
  def self.up
    remove_column :carrier_datas, :infinite
  end

  def self.down
    add_column :carrier_datas, :infinite, :float
  end
end
