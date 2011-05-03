class AddCountryToGraphs < ActiveRecord::Migration
  def self.up
    add_column :graphs, :country, :string
  end

  def self.down
    remove_column :graphs, :country
  end
end
