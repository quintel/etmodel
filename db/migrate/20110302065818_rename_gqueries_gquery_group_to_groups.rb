class RenameGqueriesGqueryGroupToGroups < ActiveRecord::Migration
  def self.up
    if table_exists?('gqueries_gquery_group')
      rename_table :gqueries_gquery_group, :gqueries_gquery_groups
    end
  end

  def self.down
    rename_table :gqueries_gquery_groups, :gqueries_gquery_group
  end
end