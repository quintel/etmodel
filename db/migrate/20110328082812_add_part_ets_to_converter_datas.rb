class AddPartEtsToConverterDatas < ActiveRecord::Migration
  def self.up
    add_column :converter_datas, :part_ets, :float
  end

  def self.down
    remove_column :converter_datas, :part_ets
  end
end
