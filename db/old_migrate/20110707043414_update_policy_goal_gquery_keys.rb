class UpdatePolicyGoalGqueryKeys < ActiveRecord::Migration
  def self.up
    gqueries = Api::Gquery.all
    PolicyGoal.all.each do |pg|
      gquery_value_id = gqueries.detect{|g| g.key == "policy_goal_#{pg.key}_value"}.id
      gquery_start_id = gqueries.detect{|g| g.key == "policy_goal_#{pg.key}_start_value"}.id
      gquery_reached_id = gqueries.detect{|g| g.key == "policy_goal_#{pg.key}_reached"}.id
      pg.update_attributes :query => gquery_value_id,
                           :start_value_query => gquery_start_id,
                           :reached_query => gquery_reached_id
    end
  end

  def self.down
  end
end
