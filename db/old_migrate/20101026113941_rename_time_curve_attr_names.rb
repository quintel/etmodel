class RenameTimeCurveAttrNames < ActiveRecord::Migration
  def self.up
    TimeCurveEntry.update_all("value_type = 'useable_heat_output_slot_conversion'", "value_type = 'useable_heat_output_link_share'")
    TimeCurveEntry.update_all("value_type = 'electricity_output_slot_conversion'", "value_type = 'electricity_output_link_share'")
    TimeCurveEntry.update_all("value_type = 'loss_output_slot_conversion'", "value_type = 'loss_output_link_share'")
  end

  def self.down
  end
end
