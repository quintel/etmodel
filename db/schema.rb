# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_11_03_142812) do
  create_table "esdl_suite_ids", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "access_token", limit: 2048
    t.string "refresh_token", limit: 2048
    t.datetime "expires_at", precision: nil
    t.index ["user_id"], name: "index_esdl_suite_ids_on_user_id", unique: true
  end

  create_table "featured_scenarios", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "saved_scenario_id", null: false
    t.string "group"
    t.string "title_en", null: false
    t.string "title_nl", null: false
    t.text "description_en"
    t.text "description_nl"
    t.string "featured_owner"
    t.index ["saved_scenario_id"], name: "index_featured_scenarios_on_saved_scenario_id", unique: true
  end

  create_table "saved_scenario_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "saved_scenario_id", null: false
    t.integer "role_id", null: false
    t.integer "user_id"
    t.string "user_email"
    t.index ["saved_scenario_id", "user_email"], name: "saved_scenario_users_saved_scenario_id_user_email_idx", unique: true
    t.index ["saved_scenario_id", "user_id", "role_id"], name: "saved_scenario_users_saved_scenario_id_user_id_role_id_idx"
    t.index ["saved_scenario_id", "user_id"], name: "saved_scenario_users_saved_scenario_id_user_id_idx", unique: true
    t.index ["user_email"], name: "saved_scenario_users_user_email_idx"
  end

  create_table "saved_scenarios", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "scenario_id", null: false
    t.text "scenario_id_history"
    t.string "title", null: false
    t.text "description"
    t.string "area_code", null: false
    t.integer "end_year", null: false
    t.boolean "private", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_saved_scenarios_on_discarded_at"
    t.index ["scenario_id"], name: "index_saved_scenarios_on_scenario_id"
  end

  create_table "sessions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "session_id", limit: 191, null: false
    t.text "data", size: :medium
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "surveys", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "background", limit: 256
    t.integer "how_often"
    t.text "typical_tasks"
    t.integer "how_easy"
    t.integer "how_useful"
    t.text "feedback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_surveys_on_user_id"
  end

  create_table "users", id: :bigint, default: nil, charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "esdl_suite_ids", "users"
  add_foreign_key "featured_scenarios", "saved_scenarios"
  add_foreign_key "surveys", "users"
end
