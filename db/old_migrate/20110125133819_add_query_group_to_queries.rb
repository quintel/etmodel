class AddQueryGroupToQueries < ActiveRecord::Migration
  def self.up
    add_column :gqueries, :gquery_group_id, :string
  end

  def self.down
    remove_column :gqueries, :gquery_group_id
  end
end