class RemoveUserUpdatesFromScenarios < ActiveRecord::Migration
  def self.up
    remove_column :scenarios, :user_updates
  end

  def self.down
    add_column :scenarios, :user_updates, :text
  end
end
