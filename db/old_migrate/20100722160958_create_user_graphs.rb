class Graph < ActiveRecord::Base
end

class CreateUserGraphs < ActiveRecord::Migration
  def self.up
    create_table :user_graphs, :force => true do |t|
      t.integer :blueprint_id
      t.integer :graph_data_id

      t.timestamps
    end

    # populate user_graphs table
    Graph.find_each do |graph|
      gid = graph.id
      UserGraph.create!(:blueprint_id => gid, :graph_data_id => gid)
    end

  end

  def self.down
    drop_table :user_graphs
  end
end
