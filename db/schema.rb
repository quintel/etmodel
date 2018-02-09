# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180209102539) do

  create_table "area_dependencies", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "dependent_on"
    t.text "description"
    t.integer "dependable_id"
    t.string "dependable_type"
    t.index ["dependable_id", "dependable_type"], name: "index_area_dependencies_on_dependable_id_and_dependable_type"
  end

  create_table "constraints", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "key"
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

  create_table "descriptions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.text "content_en"
    t.text "short_content_en"
    t.integer "describable_id"
    t.string "describable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "content_nl"
    t.text "short_content_nl"
    t.index ["describable_id", "describable_type"], name: "index_descriptions_on_describable_id_and_describable_type"
  end

  create_table "general_user_notifications", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "key"
    t.string "notification_nl"
    t.string "notification_en"
    t.boolean "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "input_elements", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "key"
    t.string "share_group"
    t.float "step_value", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "unit"
    t.boolean "fixed"
    t.text "comments"
    t.string "interface_group"
    t.string "command_type"
    t.string "related_converter"
    t.integer "slide_id"
    t.integer "position"
    t.index ["command_type"], name: "index_input_elements_on_command_type"
    t.index ["key"], name: "unique api key", unique: true
    t.index ["position"], name: "index_input_elements_on_position"
    t.index ["slide_id"], name: "index_input_elements_on_slide_id"
  end

  create_table "output_element_series", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
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

  create_table "output_element_types", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "output_elements", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
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
    t.string "key", null: false
    t.float "max_axis_value", limit: 24
    t.float "min_axis_value", limit: 24
    t.boolean "hidden", default: false
    t.boolean "requires_merit_order", default: false
    t.index ["hidden"], name: "index_output_elements_on_hidden"
    t.index ["key"], name: "index_output_elements_on_key"
  end

  create_table "prediction_measures", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.integer "prediction_id"
    t.string "name"
    t.integer "impact"
    t.integer "cost"
    t.integer "year_start"
    t.string "actor"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "year_end"
    t.index ["prediction_id"], name: "index_prediction_measures_on_prediction_id"
  end

  create_table "prediction_values", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.integer "prediction_id"
    t.float "value", limit: 24
    t.integer "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["prediction_id"], name: "index_prediction_values_on_prediction_id"
    t.index ["year"], name: "index_prediction_values_on_year"
  end

  create_table "predictions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.integer "input_element_id"
    t.integer "user_id"
    t.boolean "expert"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "description"
    t.string "title"
    t.string "area"
    t.index ["area"], name: "index_predictions_on_area"
    t.index ["input_element_id"], name: "index_predictions_on_input_element_id"
    t.index ["user_id"], name: "index_predictions_on_user_id"
  end

  create_table "roles", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "saved_scenarios", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "user_id", null: false
    t.integer "scenario_id", null: false
    t.text "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["scenario_id"], name: "index_saved_scenarios_on_scenario_id"
    t.index ["user_id"], name: "index_saved_scenarios_on_user_id"
  end

  create_table "sessions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "sidebar_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "key"
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

  create_table "slides", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "general_sub_header"
    t.string "group_sub_header"
    t.string "subheader_image"
    t.string "key"
    t.integer "position"
    t.integer "sidebar_item_id"
    t.integer "output_element_id"
    t.integer "alt_output_element_id"
    t.index ["key"], name: "index_slides_on_key"
    t.index ["position"], name: "index_slides_on_position"
    t.index ["sidebar_item_id"], name: "index_slides_on_sidebar_item_id"
  end

  create_table "tabs", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "key"
    t.string "nl_vimeo_id"
    t.string "en_vimeo_id"
    t.integer "position"
    t.index ["key"], name: "index_tabs_on_key"
    t.index ["position"], name: "index_tabs_on_position"
  end

  create_table "targets", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "code"
    t.string "query"
    t.string "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "display_format"
    t.string "reached_query"
    t.string "target_query"
    t.index ["code"], name: "index_policy_goals_on_key"
  end

  create_table "texts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "key"
    t.text "content_en"
    t.text "content_nl"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "title_en"
    t.string "title_nl"
    t.text "short_content_en"
    t.text "short_content_nl"
    t.index ["key"], name: "index_translations_on_key"
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "company_school"
    t.boolean "allow_news", default: false
    t.string "heared_first_at", default: ".."
    t.string "crypted_password"
    t.string "password_salt"
    t.string "persistence_token", null: false
    t.string "perishable_token", null: false
    t.integer "login_count", default: 0, null: false
    t.integer "failed_login_count", default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string "current_login_ip"
    t.string "last_login_ip"
    t.integer "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "phone_number"
    t.string "group"
    t.integer "teacher_id"
    t.integer "student_id"
    t.index ["email"], name: "index_users_on_email"
  end

end
