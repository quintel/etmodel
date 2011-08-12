class RemoveCurveTypeFromPredictions < ActiveRecord::Migration
  def self.up
    remove_column :predictions, :curve_type
  end

  def self.down
    add_column :predictions, :curve_type, :string
  end
end
