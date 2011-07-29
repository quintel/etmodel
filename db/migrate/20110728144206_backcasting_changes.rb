class BackcastingChanges < ActiveRecord::Migration
  def self.up
    add_column :predictions, :title, :string
    remove_column :prediction_values, :min
    remove_column :prediction_values, :max
    rename_column :prediction_values, :best, :value
    add_column :prediction_measures, :year_end, :integer
    change_column :prediction_measures, :impact, :integer
    change_column :prediction_measures, :cost, :integer
    
    add_index :prediction_values, :year
  end

  def self.down
    remove_column :predictions, :title
    add_column :prediction_values, :min, :float
    add_column :prediction_values, :max, :float
    rename_column :prediction_values, :value, :best
    remove_column :prediction_measures, :year_end
    change_column :prediction_measures, :impact, :float
    change_column :prediction_measures, :cost, :float
  end
end
