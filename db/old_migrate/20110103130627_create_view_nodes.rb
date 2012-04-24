class CreateViewNodes < ActiveRecord::Migration
  def self.up
    create_table :view_nodes, :force => true do |t|
      t.string :key
      t.references :element, :polymorphic => true
    end
  end

  def self.down
    drop_table :view_nodes
  end
end
