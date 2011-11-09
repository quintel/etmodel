class RemovePolicyGoalStartValue < ActiveRecord::Migration
  def self.up
    remove_column :policy_goals, :start_value_query
  end

  def self.down
    add_column :policy_goals, :start_value_query, :string
  end
end
