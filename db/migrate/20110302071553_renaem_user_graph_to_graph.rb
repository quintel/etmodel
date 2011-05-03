class RenaemUserGraphToGraph < ActiveRecord::Migration
  def self.up
    drop_table :graphs if table_exists?(:graphs)
    rename_table :user_graphs, :graphs
  end

  def self.down
    rename_table :graphs, :user_graphs
  end
end