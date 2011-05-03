class CreateYearValues < ActiveRecord::Migration
  def self.up
    create_table :year_values do |t|
      t.integer :year
      t.float :value
      t.text :description
      t.references :value_by_year, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :year_values
  end
end
