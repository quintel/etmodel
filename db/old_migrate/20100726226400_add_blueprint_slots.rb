class Conversion < ActiveRecord::Base
end

class AddBlueprintSlots < ActiveRecord::Migration
  def self.up

    # populate blueprint_slot and slot_data tables
    Conversion.find_each do |conv|
      if conv.input
        bps = BlueprintSlot.create!(
                :blueprint_id => conv.graph_id,
                :blueprint_converter_id => conv.converter_id,
                :blueprint_carrier_id => conv.carrier_id,
                :direction => BlueprintSlot::INPUT_DIRECTION)
        SlotData.create!(:graph_data_id => conv.graph_id,
                         :blueprint_slot_id => bps.id,
                         :conversion => conv.input)
      end

      if conv.output
        bps = BlueprintSlot.create!(
                :blueprint_id => conv.graph_id,
                :blueprint_converter_id => conv.converter_id,
                :blueprint_carrier_id => conv.carrier_id,
                :direction => BlueprintSlot::OUTPUT_DIRECTION)
        SlotData.create!(:graph_data_id => conv.graph_id,
                         :blueprint_slot_id => bps.id,
                         :conversion => conv.output)
      end

    end
  end

  def self.down
    BlueprintSlot.all.each {|bs| bs.destroy!}
    SlotData.all.each {|sd| sd.destroy!}
  end
end
