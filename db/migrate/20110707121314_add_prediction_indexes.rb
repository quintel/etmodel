class AddPredictionIndexes < ActiveRecord::Migration
  def self.up
    add_index :prediction_measures, :prediction_id
    add_index :prediction_values, :prediction_id
    add_index :predictions, :input_element_id
    add_index :predictions, :user_id
  end

  def self.down
  end
end
