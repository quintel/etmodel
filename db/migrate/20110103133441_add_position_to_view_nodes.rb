class AddPositionToViewNodes < ActiveRecord::Migration
  def self.up
    add_column :view_nodes, :position, :integer
    add_column :view_nodes, :ancestry_depth, :integer, :default => 0
    ViewNode.rebuild_depth_cache!
  end

  def self.down
    remove_column :view_nodes, :position
    remove_column :view_nodes, :ancestry_depth
  end
end
