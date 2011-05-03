class CreateExpertPredictions < ActiveRecord::Migration
  def self.up
    create_table :expert_predictions do |t|
      t.integer :input_element_id
      t.string :name
      t.string :extra_key
      t.timestamps
      t.string :key
    end
  end

  def self.down
    drop_table :expert_predictions
  end
end
