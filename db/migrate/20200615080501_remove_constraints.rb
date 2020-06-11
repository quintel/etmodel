class RemoveConstraints < ActiveRecord::Migration[5.2]
  def up
    drop_table :constraints
  end

  def down
    create_table "constraints", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
      t.string "key", limit: 191
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "gquery_key"
      t.string "group", limit: 25, null: false
      t.integer "position"
      t.boolean "disabled", default: false
      t.integer "output_element_id"
      t.index ["disabled"], name: "index_constraints_on_disabled"
      t.index ["key"], name: "index_constraints_on_key"
      t.index ["position"], name: "index_constraints_on_position"
    end
  end
end
