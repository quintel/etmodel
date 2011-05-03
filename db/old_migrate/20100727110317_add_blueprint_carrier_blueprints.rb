class Carrier < ActiveRecord::Base
end

class AddBlueprintCarrierBlueprints < ActiveRecord::Migration

  # temporary class used to create blueprint_carriers_blueprints
  class BlueprintCarrierBlueprint < ActiveRecord::Base
    set_table_name 'blueprint_carriers_blueprints'
  end

  def self.up
    Carrier.find_each do |conv|
      BlueprintCarrierBlueprint.create!(:blueprint_carrier_id => conv.excel_id, :blueprint_id => conv.graph_id)
    end
  end

  def self.down
    BlueprintCarrierBlueprint.destroy_all
  end
end
