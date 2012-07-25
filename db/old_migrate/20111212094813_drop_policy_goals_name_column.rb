class DropPolicyGoalsNameColumn < ActiveRecord::Migration
  def self.up
    remove_column :policy_goals, :name
  end

  def self.down
    add_column :policy_goals, :name, :string
  end
end
