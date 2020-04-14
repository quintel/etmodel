class RemoveOutputElementSeries < ActiveRecord::Migration[5.2]
  def up
    drop_table :output_element_series
  end

  def down
    create_table "output_element_series", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
      t.integer "output_element_id"
      t.string "label"
      t.string "color"
      t.integer "order_by", default: 1
      t.string "group"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean "show_at_first"
      t.boolean "is_target_line"
      t.string "target_line_position"
      t.string "gquery", null: false
      t.boolean "is_1990"
      t.index ["output_element_id"], name: "index_output_element_series_on_output_element_id"
    end
  end
end
