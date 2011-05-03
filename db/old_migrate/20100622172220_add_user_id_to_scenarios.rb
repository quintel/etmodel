class AddUserIdToScenarios < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :user_id, :integer
  end

  def self.down
    remove :scenarios, :user_id
  end
end
