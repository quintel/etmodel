class CleanupDb < ActiveRecord::Migration
  def self.up
    old_models = ['Area', 
      'BlueprintConverter', 
      'CarrierData',
      'Converter',
      'Gquery', 
      'Scenario']
    Version.delete_all(:item_type  => old_models)
    drop_table :scenarios
    drop_table :constraints_root_nodes
    drop_table :policy_goals_root_nodes
    drop_table :view_nodes
    drop_table :lce_values
  end

  def self.down
  end
end
