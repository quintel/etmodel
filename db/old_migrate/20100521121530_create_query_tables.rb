class CreateQueryTables < ActiveRecord::Migration
  def self.up
    create_table :query_tables do |t|
      t.string :name
      t.text :description
      t.integer :row_count
      t.integer :column_count
      t.timestamps
    end
  end

  def self.down
    drop_table :query_tables
  end
end
