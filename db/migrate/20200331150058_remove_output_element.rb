class RemoveOutputElement < ActiveRecord::Migration[5.2]
  def up
    drop_table :output_elements
  end

  def down
    create_table "output_elements", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
      t.integer "output_element_type_id", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean "under_construction", default: false
      t.string "unit"
      t.boolean "percentage", default: false
      t.string "group"
      t.string "sub_group"
      t.boolean "show_point_label", default: false
      t.boolean "growth_chart", default: false
      t.string "key", limit: 191, null: false
      t.float "max_axis_value"
      t.float "min_axis_value"
      t.boolean "hidden", default: false
      t.boolean "requires_merit_order", default: false
      t.bigint "related_output_element_id"
      t.index ["hidden"], name: "index_output_elements_on_hidden"
      t.index ["key"], name: "index_output_elements_on_key"
      t.index ["related_output_element_id"], name: "index_output_elements_on_related_output_element_id"
    end
  end
end
