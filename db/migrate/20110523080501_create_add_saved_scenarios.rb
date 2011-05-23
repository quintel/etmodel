class CreateAddSavedScenarios < ActiveRecord::Migration
  def self.up
    create_table :saved_scenarios do |t|
      t.integer :user_id, :null => false
      t.integer :scenario_id, :null => false
      t.text :settings

      t.timestamps
    end

    add_index :saved_scenarios, :user_id
    add_index :saved_scenarios, :scenario_id
  end

  def self.down
    drop_table :saved_scenarios
  end
end
