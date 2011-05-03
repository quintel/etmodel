class DropBlueprintCarriersBlueprints < ActiveRecord::Migration
  def self.up
    drop_table :blueprint_carriers_blueprints
  end

  def self.down
    ActiveRecord::IrreversibleMigration
  end
end
