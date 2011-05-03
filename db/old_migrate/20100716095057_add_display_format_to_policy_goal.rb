class AddDisplayFormatToPolicyGoal < ActiveRecord::Migration
  def self.up
    add_column :policy_goals, :display_format, :string
  end

  def self.down
    remove_column :policy_goals, :display_format
  end
end
