class CreateRounds < ActiveRecord::Migration
  def self.up
    create_table :rounds do |t|
      t.string :name
      t.boolean :active
      t.integer :position
      t.integer :value
      t.integer :policy_goal_id
      t.boolean :completed
      t.timestamps
    end
  end

  def self.down
    drop_table :rounds
  end
end
