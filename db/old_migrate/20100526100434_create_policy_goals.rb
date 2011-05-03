class CreatePolicyGoals < ActiveRecord::Migration
  def self.up
    #add a drop here, because this table was already created in an earlier migration

    create_table(:policy_goals,:force => true) do |t|
      t.string :key
      t.string :name
      t.string :query
      t.string :start_value_query
      t.string :unit
      t.string :fulfillment_method
      t.timestamps
    end
  end

  def self.down
    drop_table :policy_goals
  end
end
