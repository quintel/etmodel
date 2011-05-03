class Converter < ActiveRecord::Base
end


class AddBlueprintConverterBlueprints < ActiveRecord::Migration

  # temporary class used to create blueprint_converters_blueprints
  class BlueprintConverterBlueprint < ActiveRecord::Base
    set_table_name 'blueprint_converters_blueprints'
  end

  def self.up
    Converter.find_each do |conv|
      BlueprintConverterBlueprint.create!(:blueprint_converter_id => conv.excel_id, :blueprint_id => conv.graph_id)
    end
  end

  def self.down
    BlueprintConverterBlueprint.destroy_all
  end
end
