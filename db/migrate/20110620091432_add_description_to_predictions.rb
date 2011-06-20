class AddDescriptionToPredictions < ActiveRecord::Migration
  def self.up
    add_column :predictions, :description, :text
  end

  def self.down
    remove_column :predictions, :description
  end
end
