class AddColumnsToCarrierDatas < ActiveRecord::Migration
  def self.up
    add_column :carrier_datas, :kg_per_liter, :float
    add_column :carrier_datas, :mj_per_kg, :float
  end

  def self.down
    remove_column :carrier_datas, :mj_per_kg
    remove_column :carrier_datas, :kg_per_liter
  end
end
