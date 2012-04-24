class AddConstraintsAndPolicyGoalsToView < ActiveRecord::Migration
  def self.up
    create_table :policy_goals_root_nodes, :force => true, :id => false do |t|
      t.integer :policy_goal_id
      t.integer :root_node_id
      t.timestamps
    end
    create_table :constraints_root_nodes, :force => true, :id => false do |t|
      t.integer :constraint_id
      t.integer :root_node_id
      t.timestamps
    end
  end

  def self.down
    drop_table :policy_goals_root_nodes
    drop_table :constraints_root_nodes
  end
end