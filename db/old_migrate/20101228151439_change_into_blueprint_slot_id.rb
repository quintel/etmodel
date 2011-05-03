class ChangeIntoBlueprintSlotId < ActiveRecord::Migration
  def self.up
    rename_column :slot_datas, :blueprint_slot_id, :slot_id
  end

  def self.down
    rename_column :slot_datas, :slot_id, :blueprint_slot_id
  end
end