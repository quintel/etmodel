class DropExpertPredictions < ActiveRecord::Migration
  def self.up
    drop_table :expert_predictions
  end

  def self.down
    puts "irreversible"
  end
end
