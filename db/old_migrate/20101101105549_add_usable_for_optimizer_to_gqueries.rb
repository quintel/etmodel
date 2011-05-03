class AddUsableForOptimizerToGqueries < ActiveRecord::Migration
  def self.up
    add_column :gqueries, :usable_for_optimizer, :boolean, :default => false
    #copy all policy goals to the gquery table
    PolicyGoal.all.each do |policy_goal|
      Gquery.create(:key => policy_goal.key, :query => policy_goal.query, :usable_for_optimizer => true)
    end
  end

  def self.down
    remove_column :gqueries, :usable_for_optimizer
  end
end
