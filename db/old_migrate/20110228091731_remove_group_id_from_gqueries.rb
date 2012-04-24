class RemoveGroupIdFromGqueries < ActiveRecord::Migration
  def self.up
    remove_column :gqueries, :gquery_group_id
  end

  def self.down
    add_column :gqueries, :gquery_group_id, :integer
  end
end
