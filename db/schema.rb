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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110620091616) do

  create_table "area_dependencies", :force => true do |t|
    t.string  "dependent_on"
    t.text    "description"
    t.integer "dependable_id"
    t.string  "dependable_type"
  end

  add_index "area_dependencies", ["dependable_id", "dependable_type"], :name => "index_area_dependencies_on_dependable_id_and_dependable_type"

  create_table "constraints", :force => true do |t|
    t.string   "key"
    t.string   "name"
    t.string   "extended_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gquery_key"
  end

  create_table "constraints_root_nodes", :id => false, :force => true do |t|
    t.integer  "constraint_id"
    t.integer  "root_node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "constraints_root_nodes", ["constraint_id"], :name => "index_constraints_root_nodes_on_constraint_id"
  add_index "constraints_root_nodes", ["root_node_id"], :name => "index_constraints_root_nodes_on_root_node_id"

  create_table "descriptions", :force => true do |t|
    t.text     "content_en"
    t.text     "short_content_en"
    t.integer  "describable_id"
    t.string   "describable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content_nl"
    t.text     "short_content_nl"
  end

  add_index "descriptions", ["describable_id", "describable_type"], :name => "index_descriptions_on_describable_id_and_describable_type"

  create_table "expert_predictions", :force => true do |t|
    t.integer  "input_element_id"
    t.string   "name"
    t.string   "extra_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key"
  end

  add_index "expert_predictions", ["input_element_id"], :name => "index_expert_predictions_on_input_element_id"

  create_table "general_user_notifications", :force => true do |t|
    t.string   "key"
    t.string   "notification_nl"
    t.string   "notification_en"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key"
    t.string   "shortcut"
    t.integer  "group_id"
  end

  add_index "groups", ["group_id"], :name => "index_groups_on_group_id"

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

  create_table "input_elements", :force => true do |t|
    t.string   "name"
    t.string   "key"
    t.text     "keys"
    t.string   "attr_name"
    t.integer  "slide_id"
    t.string   "share_group"
    t.string   "start_value_gql"
    t.string   "min_value_gql"
    t.string   "max_value_gql"
    t.float    "min_value"
    t.float    "max_value"
    t.float    "start_value"
    t.float    "order_by"
    t.decimal  "step_value",                :precision => 4, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_type"
    t.string   "unit"
    t.float    "factor"
    t.string   "input_element_type"
    t.string   "label"
    t.text     "comments"
    t.string   "update_value"
    t.integer  "complexity",                                              :default => 1
    t.string   "interface_group"
    t.string   "update_max"
    t.boolean  "locked_for_municipalities"
    t.string   "label_query"
  end

  add_index "input_elements", ["key"], :name => "unique api key"
  add_index "input_elements", ["slide_id"], :name => "index_input_elements_on_slide_id"

  create_table "interfaces", :force => true do |t|
    t.string   "key"
    t.text     "structure"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interfaces", ["enabled"], :name => "index_interfaces_on_enabled"
  add_index "interfaces", ["key"], :name => "index_interfaces_on_key"

  create_table "lce_values", :force => true do |t|
    t.string   "using_country"
    t.string   "origin_country"
    t.float    "co2_exploration_per_mj"
    t.float    "co2_extraction_per_mj"
    t.float    "co2_treatment_per_mj"
    t.float    "co2_transportation_per_mj"
    t.float    "co2_conversion_per_mj"
    t.float    "co2_waste_treatment_per_mj"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "carrier"
  end

  create_table "output_element_series", :force => true do |t|
    t.integer  "output_element_id"
    t.string   "key"
    t.string   "label"
    t.string   "color"
    t.integer  "order_by"
    t.string   "group"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_label"
    t.boolean  "show_at_first"
    t.boolean  "is_target"
    t.string   "position"
    t.string   "historic_key"
    t.string   "expert_key"
    t.string   "gquery",            :null => false
  end

  add_index "output_element_series", ["output_element_id"], :name => "index_output_element_series_on_output_element_id"

  create_table "output_element_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "output_elements", :force => true do |t|
    t.string   "name"
    t.integer  "output_element_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "under_construction",     :default => false
    t.integer  "legend_columns"
    t.string   "legend_location"
    t.string   "unit"
    t.boolean  "percentage"
    t.string   "group"
    t.boolean  "show_point_label"
    t.boolean  "growth_chart"
    t.string   "key"
  end

  add_index "output_elements", ["key"], :name => "index_output_elements_on_key"

  create_table "page_titles", :force => true do |t|
    t.string   "controller"
    t.string   "action"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partners", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "country"
    t.integer  "time"
    t.boolean  "repeat_any_other", :default => false
    t.string   "subheader"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "place",            :default => "right"
    t.string   "long_name"
  end

  create_table "policy_goals", :force => true do |t|
    t.string   "key"
    t.string   "name"
    t.string   "query"
    t.string   "start_value_query"
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_format"
    t.string   "reached_query"
  end

  create_table "policy_goals_root_nodes", :id => false, :force => true do |t|
    t.integer  "policy_goal_id"
    t.integer  "root_node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prediction_values", :force => true do |t|
    t.integer  "prediction_id"
    t.float    "min"
    t.float    "best"
    t.float    "max"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "predictions", :force => true do |t|
    t.integer  "input_element_id"
    t.integer  "user_id"
    t.boolean  "expert"
    t.string   "curve_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "press_releases", :force => true do |t|
    t.string   "medium"
    t.string   "release_type"
    t.datetime "release_date"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
    t.integer  "position"
    t.integer  "value"
    t.integer  "policy_goal_id"
    t.boolean  "completed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "saved_scenarios", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.integer  "scenario_id", :null => false
    t.text     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "saved_scenarios", ["scenario_id"], :name => "index_saved_scenarios_on_scenario_id"
  add_index "saved_scenarios", ["user_id"], :name => "index_saved_scenarios_on_user_id"

  create_table "scenarios", :force => true do |t|
    t.string   "author"
    t.string   "title"
    t.text     "description"
    t.text     "user_updates"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "user_values"
    t.integer  "end_year",           :default => 2040
    t.string   "country"
    t.boolean  "in_start_menu"
    t.string   "region"
    t.integer  "user_id"
    t.integer  "complexity",         :default => 3
    t.string   "scenario_type"
    t.integer  "preset_scenario_id"
    t.string   "type"
    t.string   "api_session_key"
    t.text     "lce_settings"
  end

  create_table "sidebar_items", :force => true do |t|
    t.string   "name"
    t.string   "key"
    t.string   "section"
    t.text     "percentage_bar_query"
    t.integer  "order_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nl_vimeo_id"
    t.string   "en_vimeo_id"
  end

  create_table "slides", :force => true do |t|
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "name"
    t.integer  "default_output_element_id"
    t.integer  "order_by"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sub_header"
    t.integer  "complexity",                :default => 1
    t.string   "sub_header2"
    t.string   "subheader_image"
    t.string   "key"
  end

  add_index "slides", ["key"], :name => "index_slides_on_key"

  create_table "tabs", :force => true do |t|
    t.string "key"
    t.string "nl_vimeo_id"
    t.string "en_vimeo_id"
  end

  create_table "translations", :force => true do |t|
    t.string   "key"
    t.text     "content_en"
    t.text     "content_nl"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "translations", ["key"], :name => "index_translations_on_key"

  create_table "users", :force => true do |t|
    t.string   "name",                                  :null => false
    t.string   "email",                                 :null => false
    t.string   "company_school"
    t.boolean  "allow_news",         :default => true
    t.string   "heared_first_at",    :default => ".."
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                     :null => false
    t.string   "perishable_token",                      :null => false
    t.integer  "login_count",        :default => 0,     :null => false
    t.integer  "failed_login_count", :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
    t.string   "group"
    t.string   "trackable",          :default => "0"
    t.boolean  "send_score",         :default => false
    t.boolean  "new_round"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["trackable"], :name => "index_users_on_trackable"

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "view_nodes", :force => true do |t|
    t.string  "key"
    t.integer "element_id"
    t.string  "element_type"
    t.string  "ancestry"
    t.integer "position"
    t.integer "ancestry_depth", :default => 0
    t.string  "type"
  end

  add_index "view_nodes", ["element_id", "element_type"], :name => "index_view_nodes_on_element_id_and_element_type"
  add_index "view_nodes", ["type"], :name => "index_view_nodes_on_type"

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
