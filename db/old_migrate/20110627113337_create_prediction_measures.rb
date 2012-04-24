class CreatePredictionMeasures < ActiveRecord::Migration
  def self.up
    create_table :prediction_measures do |t|
      t.integer :prediction_id
      t.string :name
      t.float :impact
      t.float :cost
      t.integer :year_start
      t.string :actor
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :prediction_measures
  end
end
