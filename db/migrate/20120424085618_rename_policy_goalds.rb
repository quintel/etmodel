class RenamePolicyGoalds < ActiveRecord::Migration
  def up
    rename_table :policy_goals, :targets
    rename_column :targets, :key, :code
    PageTitle.update_all "controller = 'targets'", "controller = 'policy'"
  end

  def down
    rename_table :targets, :policy_goals
    rename_table :policy_goals, :code, :key
    PageTitle.update_all "controller = 'policy'", "controller = 'targets'"
  end
end
