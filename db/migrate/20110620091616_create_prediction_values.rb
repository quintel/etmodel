class CreatePredictionValues < ActiveRecord::Migration
  def self.up
    create_table :prediction_values do |t|
      t.integer :prediction_id
      t.float :min
      t.float :best
      t.float :max
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :prediction_values
  end
end
