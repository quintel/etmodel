class CreateBlueprintJoinTables < ActiveRecord::Migration
  def self.up
    create_table :blueprint_converters_blueprints, :force => true, :id => false do |t|
      t.integer :blueprint_converter_id
      t.integer :blueprint_id
    end
    create_table :blueprint_carriers_blueprints, :force => true, :id => false do |t|
      t.integer :blueprint_carrier_id
      t.integer :blueprint_id
    end
  end

  def self.down
    drop_table :blueprint_converters_blueprints
    drop_table :blueprint_carriers_blueprints
  end
end
