class DropTargetUserValueQuery < ActiveRecord::Migration
  def up
    remove_column :targets, :user_value_query
  end

  def down
    add_column :targets, :user_value_query, :string
  end
end
