class IndexesAreGood < ActiveRecord::Migration
  def self.up
    add_index :constraints_root_nodes, :constraint_id
    add_index :constraints_root_nodes, :root_node_id

    add_index :gqueries_gquery_groups, :gquery_id
    add_index :gqueries_gquery_groups, :gquery_group_id

    add_index :groups, :group_id

    add_index :historic_serie_entries, :historic_serie_id

    add_index :translations, :key

    add_index :users, :email

    add_index :view_nodes, [:element_id, :element_type]
    add_index :view_nodes, :type
  end

  def self.down
  end
end
