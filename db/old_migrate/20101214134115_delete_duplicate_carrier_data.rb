class DeleteDuplicateCarrierData < ActiveRecord::Migration
  def self.up
    Area.all.each do |area|
      graph_datas = GraphData.find_all_by_region_code(area.country)
      graph_datas_old = graph_datas[0...-1]
      
      graph_datas_old.each do |gd|
        gd.carrier_datas.delete_all
      end
    end
    CarrierData.delete_all("area_id IS NULL")
  end

  def self.down
    ActiveRecord::IrreversibleMigration
  end
end
