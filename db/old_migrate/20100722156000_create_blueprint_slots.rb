class CreateBlueprintSlots < ActiveRecord::Migration
  def self.up

    create_table :blueprint_slots, :force => true do |t|
      t.integer :blueprint_id
      t.integer :blueprint_converter_id
      t.integer :blueprint_carrier_id
      t.integer :direction
    end

    create_table :slot_datas, :force => true do |t|
      t.integer :graph_data_id
      t.integer :blueprint_slot_id
      t.float :conversion
    end
  end

  def self.down
    drop_table :blueprint_slots
    drop_table :slot_data
  end
end
