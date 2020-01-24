class RemoveSlides < ActiveRecord::Migration[5.2]
  def up
    drop_table :slides
  end

  def down
    create_table "slides", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
      t.string "image"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "general_sub_header"
      t.string "group_sub_header"
      t.string "subheader_image"
      t.string "key", limit: 191
      t.integer "position"
      t.integer "sidebar_item_id"
      t.integer "output_element_id"
      t.integer "alt_output_element_id"
      t.index ["key"], name: "index_slides_on_key"
      t.index ["position"], name: "index_slides_on_position"
      t.index ["sidebar_item_id"], name: "index_slides_on_sidebar_item_id"
    end
  end
end
