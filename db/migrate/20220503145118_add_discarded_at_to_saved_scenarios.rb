class AddDiscardedAtToSavedScenarios < ActiveRecord::Migration[7.0]
  def change
    add_column :saved_scenarios, :discarded_at, :datetime
    add_index :saved_scenarios, :discarded_at
  end
end
