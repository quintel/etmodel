class DropGqueriesTable < ActiveRecord::Migration
  def self.up
    drop_table :gqueries
    drop_table :gqueries_gquery_groups
    drop_table :gquery_groups
  end

  def self.down
    create_table "gqueries", :force => true do |t|
      t.string   "key"
      t.text     "query"
      t.string   "name"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "not_cacheable",        :default => false
      t.boolean  "usable_for_optimizer", :default => false
    end

    create_table "gqueries_gquery_groups", :id => false, :force => true do |t|
      t.string "gquery_id"
      t.string "gquery_group_id"
    end

    add_index "gqueries_gquery_groups", ["gquery_group_id"], :name => "index_gqueries_gquery_groups_on_gquery_group_id"
    add_index "gqueries_gquery_groups", ["gquery_id"], :name => "index_gqueries_gquery_groups_on_gquery_id"

    create_table "gquery_groups", :force => true do |t|
      t.string   "group_key"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "description"
    end
  end
end
