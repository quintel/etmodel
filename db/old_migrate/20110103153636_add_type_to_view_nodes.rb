class AddTypeToViewNodes < ActiveRecord::Migration
  def self.up
    add_column :view_nodes, :type, :string
  end

  def self.down
    remove_column :view_nodes, :type
  end
end