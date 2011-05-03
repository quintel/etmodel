class Graph < ActiveRecord::Base
end

class AddBlueprintConvertersGroups < ActiveRecord::Migration

 # temporary class used to create blueprint_converters_groups
  class BlueprintConverterGroup < ActiveRecord::Base
    set_table_name 'blueprint_converters_groups'
  end

  def self.up
    if graph = Graph.find(403) rescue nil
      cs = graph.converters.find(:all, :include => :groups)
      cs.each do |c|
        c.groups.each {|g| BlueprintConverterGroup.create!(:blueprint_converter_id => c.excel_id, :group_id => g.id) }
      end
    end
  end

  def self.down
    BlueprintConverterGroup.destroy_all
  end
end
