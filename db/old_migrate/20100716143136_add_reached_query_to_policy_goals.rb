class AddReachedQueryToPolicyGoals < ActiveRecord::Migration
  def self.up
    add_column :policy_goals, :reached_query, :string
    remove_column :policy_goals, :fulfillment_method
  end

  def self.down
    remove_column :policy_goals, :reached_query
    add_column :policy_goals, :fulfillment_method, :string
  end
end
