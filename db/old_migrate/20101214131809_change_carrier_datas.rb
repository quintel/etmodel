class ChangeCarrierDatas < ActiveRecord::Migration
  def self.up
    add_column :carrier_datas, :area_id, :integer
    CarrierData.find(:all, :include => :graph_data).each do |cd|
      cd.area_id = Area.find_by_country(cd.graph_data.andand.region_code).andand.id
      cd.save
    end
  end

  def self.down
    remove_column :carrier_datas, :area_id
  end
end