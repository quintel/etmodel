class PolicyGoalsUseGqueryId < ActiveRecord::Migration
  def self.up
    add_column :policy_goals, :target_query, :integer
    add_column :policy_goals, :user_value_query, :integer

    PolicyGoal.reset_column_information

    gqueries = Api::Gquery.all
    h = {}

    gqueries.each do |g|
      h[g.key] = g.id
    end

    PolicyGoal.find_each do |g|
      g.target_query     = h["policy_goal_#{g.key}_target_value"]
      g.user_value_query = h["policy_goal_#{g.key}_user_value"]
      g.save
    end
  end

  def self.down
    remove_column :policy_goals, :target_query
    remove_column :policy_goals, :user_value_query
  end
end
