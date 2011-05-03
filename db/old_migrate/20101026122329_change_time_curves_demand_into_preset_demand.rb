class ChangeTimeCurvesDemandIntoPresetDemand < ActiveRecord::Migration
  def self.up
    TimeCurveEntry.update_all("value_type = 'preset_demand'", "value_type = 'demand'")
  end

  def self.down
    TimeCurveEntry.update_all("value_type = 'demand'", "value_type = 'preset_demand'")
  end
end
