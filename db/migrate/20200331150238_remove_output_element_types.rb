class RemoveOutputElementTypes < ActiveRecord::Migration[5.2]
  def up
    drop_table :output_element_types
  end

  def down
    create_table "output_element_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
      t.string "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
