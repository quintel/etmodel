class AddPresetIdToScenarios < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :preset_scenario_id, :integer
  end

  def self.down
    remove_column :scenarios, :preset_scenario_id
  end
end
