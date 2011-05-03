class RemoveDuplicateCarrierDatasInNl < ActiveRecord::Migration
  def self.up
    area = Area.find_by_country('nl')
    area.carrier_datas.group_by(&:carrier_id).each do |carrier_id, carrier_datas|
      carrier_datas.first.destroy
    end
  end

  def self.down
  end
end
