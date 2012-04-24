class RemoveUnusedAttrsFromSlides < ActiveRecord::Migration
  def self.up
    remove_column :slides, :controller_name
    remove_column :slides, :action_name
    remove_column :slides, :complexity
  end

  def self.down
    add_column :slides, :action_name, :string
    add_column :slides, :controller_name, :string
    add_column :slides, :complexity, :integer
  end
end
