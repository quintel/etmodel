class AddUserValuesToScenarios < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :user_values, :text
  end

  def self.down
    remove_column :scenarios, :user_values
  end
end
