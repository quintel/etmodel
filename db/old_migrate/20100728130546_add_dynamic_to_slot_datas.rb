class AddDynamicToSlotDatas < ActiveRecord::Migration
  def self.up
    add_column :slot_datas, :dynamic, :boolean

    SlotData.find_each do |sd|
      sd.dynamic = (sd.conversion and sd.conversion < 0.0) == true
      sd.save!
    end
  end

  def self.down
    remove_column :slot_datas, :dynamic
  end
end
