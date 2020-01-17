class RemoveTabsAndSidebarItems < ActiveRecord::Migration[5.2]
  def up
    drop_table :tabs
    drop_table :sidebar_items
  end

  def down
    create_table "tabs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
      t.string "key", limit: 191
      t.string "nl_vimeo_id"
      t.string "en_vimeo_id"
      t.integer "position"
      t.index ["key"], name: "index_tabs_on_key"
      t.index ["position"], name: "index_tabs_on_position"
    end

    create_table "sidebar_items", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
      t.string "key", limit: 191
      t.string "section"
      t.text "percentage_bar_query"
      t.string "nl_vimeo_id"
      t.string "en_vimeo_id"
      t.integer "tab_id"
      t.integer "position"
      t.integer "parent_id"
      t.index ["key"], name: "index_sidebar_items_on_key"
      t.index ["parent_id"], name: "index_sidebar_items_on_parent_id"
      t.index ["position"], name: "index_sidebar_items_on_position"
      t.index ["tab_id"], name: "index_sidebar_items_on_tab_id"
    end
  end
end
