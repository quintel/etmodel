class RegenerateInterfaces < ActiveRecord::Migration
  def self.up
    Interface.destroy_all
    ViewNode::Root.find_each do |r|
      Interface.create!(
        :key       => r.key,
        :enabled   => true,
        :structure => r.tree_to_yml
      )
    end

    add_index :constraints, :key
    add_index :policy_goals, :key
    add_index :sidebar_items, :key
    add_index :tabs, :key
  end

  def self.down
  end
end
