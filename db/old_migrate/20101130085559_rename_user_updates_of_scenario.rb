class RenameUserUpdatesOfScenario < ActiveRecord::Migration
  def self.up
    rename_column :blackbox_scenarios, :user_updates, :update_statements
  end

  def self.down
    rename_column :blackbox_scenarios, :update_statements, :user_updates
  end
end