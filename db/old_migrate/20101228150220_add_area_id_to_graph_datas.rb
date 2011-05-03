class AddAreaIdToGraphDatas < ActiveRecord::Migration
  def self.up
    add_column :graph_datas, :area_id, :integer
    GraphData.all.each do |graph_data|
      area_id = Area.find_by_country(graph_data.region_code).andand.id
      graph_data.update_attribute :area_id, area_id
      puts "GraphData with id: #{graph_data.id} has region_code #{graph_data.region_code} that could not be found" unless area_id
    end
  end

  def self.down
    remove_column :graph_datas, :area_id
  end
end
