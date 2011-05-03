class CreateGraphs < ActiveRecord::Migration
  def self.up
    create_table :graphs, :force => true do |t|
      t.string :name
      t.string :version
      t.timestamps
    end
  end

  def self.down
    drop_table :graphs
  end
end
