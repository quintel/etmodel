class CreateQueryTableCells < ActiveRecord::Migration
  def self.up
    create_table :query_table_cells do |t|
      t.integer :query_table_id
      t.integer :row
      t.integer :column
      t.string :name
      t.text :gquery
      t.timestamps
    end
  end

  def self.down
    drop_table :query_table_cells
  end
end
