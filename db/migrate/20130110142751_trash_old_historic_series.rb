class TrashOldHistoricSeries < ActiveRecord::Migration
  def up
    drop_table :year_values
    drop_table :historic_series
    drop_table :historic_serie_entries
  end

  def down
    create_table "historic_serie_entries", :force => true do |t|
      t.integer  "historic_serie_id"
      t.integer  "year"
      t.float    "value"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "historic_serie_entries", ["historic_serie_id"], :name => "index_historic_serie_entries_on_historic_serie_id"

    create_table "historic_series", :force => true do |t|
      t.string   "key"
      t.string   "area_code"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "year_values", :force => true do |t|
      t.integer  "year"
      t.float    "value"
      t.text     "description"
      t.integer  "value_by_year_id"
      t.string   "value_by_year_type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "year_values", ["value_by_year_id", "value_by_year_type"], :name => "index_year_values_on_value_by_year_id_and_value_by_year_type"
  end
end
