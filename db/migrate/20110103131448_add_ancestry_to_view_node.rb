class AddAncestryToViewNode < ActiveRecord::Migration
  def self.up
    add_column :view_nodes, :ancestry, :string
  end

  def self.down
    remove_column :view_nodes, :ancestry
  end
end
