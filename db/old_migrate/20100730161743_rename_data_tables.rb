class RenameDataTables < ActiveRecord::Migration
  def self.up
    rename_table :carriers, :carrier_datas
    rename_table :converters, :converter_datas
    rename_table :links, :link_datas
    drop_table :conversions
  end

  def self.down
    create_table "conversions", :force => true do |t|
      t.integer  "converter_id"
      t.integer  "carrier_id"
      t.float    "value"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.float    "input"
      t.float    "output"
      t.integer  "graph_id"
      t.integer  "excel_id"
    end
    rename_table :link_datas, :links
    rename_table :converter_datas, :converters
    rename_table :carrier_datas, :carriers
  end
end
