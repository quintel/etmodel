class RemoveQueryTables < ActiveRecord::Migration
  def self.up
    drop_table :query_tables
    drop_table :query_table_cells
  end

  def self.down
    create_table "query_table_cells", :force => true do |t|
      t.integer  "query_table_id"
      t.integer  "row"
      t.integer  "column"
      t.string   "name"
      t.text     "gquery"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "query_tables", :force => true do |t|
      t.string   "name"
      t.text     "description"
      t.integer  "row_count"
      t.integer  "column_count"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
