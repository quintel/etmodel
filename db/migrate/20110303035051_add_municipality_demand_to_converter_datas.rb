class AddMunicipalityDemandToConverterDatas < ActiveRecord::Migration
  def self.up
    add_column :converter_datas, :municipality_demand, :integer, :limit => 8
  end

  def self.down
    remove_column :converter_datas, :municipality_demand
  end
end
