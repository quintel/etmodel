class AddLceAttributesToCarrierDatas < ActiveRecord::Migration
  def self.up
    add_column :carrier_datas, :co2_exploration_per_mj, :float, :default => 0.0
    add_column :carrier_datas, :co2_extraction_per_mj, :float, :default => 0.0
    add_column :carrier_datas, :co2_treatment_per_mj, :float, :default => 0.0
    add_column :carrier_datas, :co2_transportation_per_mj, :float, :default => 0.0
    add_column :carrier_datas, :co2_waste_treatment_per_mj, :float, :default => 0.0
  end

  def self.down
    remove_column :carrier_datas, :co2_exploration_per_mj
    remove_column :carrier_datas, :co2_extraction_per_mj
    remove_column :carrier_datas, :co2_treatment_per_mj
    remove_column :carrier_datas, :co2_transportation_per_mj
    remove_column :carrier_datas, :co2_waste_treatment_per_mj
  end
end