class Graph < ActiveRecord::Base
end

class AddBlueprintsAndGraphDatas < ActiveRecord::Migration
  def self.up

    Graph.find_each do |graph|
      bp = Blueprint.new(:name => graph.name, :version => graph.version, :description => graph.description)
      bp.id = graph.id
      bp.save!

      gd = GraphData.new(:blueprint_id => graph.id, :region_code => graph.country)
      gd.id = graph.id
      gd.save!

    end
  end

  def self.down
    Blueprint.destroy_all
    GraphData.destroy_all
  end
end
