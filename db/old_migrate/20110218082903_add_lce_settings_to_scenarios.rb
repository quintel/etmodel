class AddLceSettingsToScenarios < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :lce_settings, :text
  end

  def self.down
    remove_column :scenarios, :lce_settings
  end
end
