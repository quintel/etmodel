
# == Schema Information
#
# Table name: carriers
#
#  id                         :integer(4)      not null, primary key
#  name                       :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#  graph_id                   :integer(4)
#  excel_id                   :integer(4)
#  cost_per_mj                :float
#  co2_per_mj                 :float
#  key                        :string(255)
#  sustainable                :float
#  infinite                   :float
#  typical_production_per_km2 :float
#


class RemoveUnneccessaryAttributes < ActiveRecord::Migration
  def self.up
    remove_column :carrier_datas, :key
    remove_column :carrier_datas, :name
    rename_column :carrier_datas, :excel_id, :blueprint_carrier_id
    rename_column :carrier_datas, :graph_id, :graph_data_id
  end

  def self.down
    rename_column :carrier_datas, :graph_data_id, :graph_id
    rename_column :carrier_datas, :blueprint_carrier_id
    add_column :carrier_datas, :name, :string
    add_column :carrier_datas, :key, :string
  end
end
