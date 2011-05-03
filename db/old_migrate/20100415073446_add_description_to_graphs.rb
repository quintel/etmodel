class AddDescriptionToGraphs < ActiveRecord::Migration
  def self.up
    add_column :graphs, :description, :text
  end

  def self.down
    remove_column :graphs, :description
  end
end
