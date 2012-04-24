class AddApiKeyToScenarios < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :api_session_key, :string
  end

  def self.down
    remove_column :scenarios, :api_session_key
  end
end
