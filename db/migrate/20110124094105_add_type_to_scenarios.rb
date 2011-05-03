class AddTypeToScenarios < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :type, :string
  end

  def self.down
    remove_column :scenarios, :type
  end
end
