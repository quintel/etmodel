class CreatePredictions < ActiveRecord::Migration
  def self.up
    create_table :predictions do |t|
      t.integer :input_element_id
      t.integer :user_id
      t.boolean :expert
      t.string :curve_type

      t.timestamps
    end
  end

  def self.down
    drop_table :predictions
  end
end
