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

ActiveRecord::Schema.define(:version => 20110523080501) do

  create_table "area_dependencies", :force => true do |t|
    t.string  "dependent_on"
    t.text    "description"
    t.integer "dependable_id"
    t.string  "dependable_type"
  end

  add_index "area_dependencies", ["dependable_id", "dependable_type"], :name => "index_area_dependencies_on_dependable_id_and_dependable_type"

  create_table "areas", :force => true do |t|
    t.string   "country"
    t.float    "co2_price"
    t.float    "co2_percentage_free"
    t.float    "el_import_capacity"
    t.float    "el_export_capacity"
    t.float    "co2_emission_1990"
    t.float    "co2_emission_2009"
    t.float    "co2_emission_electricity_1990"
    t.float    "roof_surface_available_pv"
    t.float    "coast_line"
    t.float    "offshore_suitable_for_wind"
    t.float    "onshore_suitable_for_wind"
    t.float    "areable_land"
    t.float    "available_land"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "land_available_for_solar"
    t.float    "km_per_car"
    t.float    "import_electricity_primary_demand_factor",              :default => 1.82
    t.float    "export_electricity_primary_demand_factor",              :default => 1.0
    t.float    "capacity_buffer_in_mj_s"
    t.float    "capacity_buffer_decentral_in_mj_s"
    t.float    "km_per_truck"
    t.float    "annual_infrastructure_cost_electricity"
    t.float    "number_households"
    t.float    "number_inhabitants"
    t.boolean  "use_network_calculations"
    t.boolean  "has_coastline"
    t.boolean  "has_mountains"
    t.boolean  "has_lignite"
    t.float    "annual_infrastructure_cost_gas"
    t.string   "entity"
    t.float    "percentage_of_new_houses"
    t.float    "recirculation"
    t.float    "heat_recovery"
    t.float    "ventilation_rate"
    t.float    "market_share_daylight_control"
    t.float    "market_share_motion_detection"
    t.float    "buildings_heating_share_offices"
    t.float    "buildings_heating_share_schools"
    t.float    "buildings_heating_share_other"
    t.float    "roof_surface_available_pv_buildings"
    t.float    "insulation_level_existing_houses"
    t.float    "insulation_level_new_houses"
    t.float    "insulation_level_schools"
    t.float    "insulation_level_offices"
    t.boolean  "has_buildings"
    t.boolean  "has_agriculture",                                       :default => true
    t.integer  "current_electricity_demand_in_mj",         :limit => 8, :default => 1
    t.boolean  "has_solar_csp"
    t.boolean  "has_old_technologies"
    t.integer  "parent_id"
  end

  create_table "attachments", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "title"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.string   "file_file_size"
    t.string   "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blackbox_gqueries", :force => true do |t|
    t.integer  "blackbox_id"
    t.integer  "blackbox_scenario_id"
    t.integer  "gquery_id"
    t.decimal  "present_value",        :precision => 30, :scale => 0
    t.decimal  "future_value",         :precision => 30, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blackbox_output_series", :force => true do |t|
    t.integer  "blackbox_id"
    t.integer  "blackbox_scenario_id"
    t.integer  "output_element_serie_id"
    t.decimal  "present_value",           :precision => 30, :scale => 0
    t.decimal  "future_value",            :precision => 30, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blackbox_scenarios", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "user_values"
    t.text     "update_statements"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blackboxes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "graph_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blueprint_layouts", :force => true do |t|
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blueprint_models", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blueprints", :force => true do |t|
    t.string   "name"
    t.string   "graph_version"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "blueprint_model_id"
  end

  create_table "blueprints_converters", :id => false, :force => true do |t|
    t.integer "converter_id"
    t.integer "blueprint_id"
  end

  add_index "blueprints_converters", ["blueprint_id"], :name => "index_blueprints_converters_on_blueprint_id"

  create_table "carrier_datas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "carrier_id"
    t.float    "cost_per_mj"
    t.float    "co2_per_mj"
    t.float    "sustainable"
    t.float    "typical_production_per_km2"
    t.integer  "area_id"
    t.float    "kg_per_liter"
    t.float    "mj_per_kg"
    t.float    "co2_exploration_per_mj",     :default => 0.0
    t.float    "co2_extraction_per_mj",      :default => 0.0
    t.float    "co2_treatment_per_mj",       :default => 0.0
    t.float    "co2_transportation_per_mj",  :default => 0.0
    t.float    "co2_waste_treatment_per_mj", :default => 0.0
  end

  create_table "carriers", :force => true do |t|
    t.integer  "carrier_id"
    t.string   "key"
    t.string   "name"
    t.boolean  "infinite"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "carrier_color"
  end

  create_table "constraints", :force => true do |t|
    t.string   "key"
    t.string   "name"
    t.string   "extended_title"
    t.string   "query"
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

  create_table "converter_datas", :force => true do |t|
    t.string   "name"
    t.integer  "preset_demand",                                     :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dataset_id"
    t.integer  "converter_id"
    t.integer  "demand_expected_value",                             :limit => 8
    t.float    "typical_capacity_gross_in_mj_s"
    t.float    "typical_capacity_effective_in_mj_s"
    t.float    "typical_thermal_capacity_effective_in_mj_yr"
    t.float    "max_capacity_factor"
    t.float    "capacity_factor_emperical_scaling_excl"
    t.float    "land_use_in_nl"
    t.float    "technical_lifetime"
    t.float    "technological_maturity"
    t.float    "lead_time"
    t.float    "construction_time"
    t.float    "net_electrical_yield"
    t.float    "net_heat_yield"
    t.float    "cost_om_fixed_per_mj"
    t.float    "cost_om_variable_ex_fuel_co2_per_mj"
    t.float    "cost_co2_capture_ex_fuel_per_mj"
    t.float    "cost_co2_transport_and_storage_per_mj"
    t.float    "cost_fuel_other_per_mj"
    t.float    "overnight_investment_ex_co2_per_mj_s"
    t.float    "overnight_investment_co2_capture_per_mj"
    t.float    "sustainable"
    t.float    "mainly_baseload"
    t.float    "intermittent"
    t.float    "cost_co2_expected_per_mje"
    t.float    "co2_production_kg_per_mj_output"
    t.integer  "use_id"
    t.integer  "sector_id"
    t.string   "key"
    t.float    "installed_capacity_effective_in_mj_s"
    t.float    "electricitiy_production_actual"
    t.float    "wacc"
    t.float    "overnight_investment_co2_capture_per_mj_s"
    t.float    "capacity_factor"
    t.float    "co2_free"
    t.text     "comment"
    t.float    "simult_wd"
    t.float    "simult_sd"
    t.float    "simult_we"
    t.float    "simult_se"
    t.float    "peak_load_units_present"
    t.float    "typical_electric_capacity"
    t.float    "typical_heat_capacity"
    t.float    "full_load_hours"
    t.float    "operation_hours"
    t.float    "operation_and_maintenance_cost_fixed"
    t.float    "operation_and_maintenance_cost_variable"
    t.float    "investment"
    t.float    "purchase_price"
    t.float    "installing_costs"
    t.float    "economic_lifetime"
    t.integer  "municipality_demand",                               :limit => 8
    t.float    "typical_input_capacity"
    t.float    "fixed_operation_and_maintenance_cost_per_mw_input"
    t.float    "residual_value_per_mw_input"
    t.float    "decommissioning_costs_per_mw_input"
    t.float    "purchase_price_per_mw_input"
    t.float    "installing_costs_per_mw_input"
    t.float    "part_ets"
  end

  add_index "converter_datas", ["dataset_id"], :name => "index_converter_datas_on_graph_data_id"

  create_table "converter_positions", :force => true do |t|
    t.integer  "converter_id"
    t.integer  "x"
    t.integer  "y"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hidden"
    t.string   "fill_color"
    t.string   "stroke_color"
    t.integer  "blueprint_layout_id"
  end

  create_table "converters", :force => true do |t|
    t.integer  "converter_id"
    t.string   "key"
    t.string   "name"
    t.integer  "use_id"
    t.integer  "sector_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "energy_balance_group"
  end

  create_table "converters_groups", :id => false, :force => true do |t|
    t.integer "converter_id"
    t.integer "group_id"
  end

  create_table "datasets", :force => true do |t|
    t.integer  "blueprint_id"
    t.string   "region_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "area_id"
  end

  add_index "datasets", ["region_code"], :name => "index_graph_datas_on_region_code"

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

  create_table "gql_test_cases", :force => true do |t|
    t.string   "name"
    t.text     "instruction"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gqueries", :force => true do |t|
    t.string   "key"
    t.text     "query"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "not_cacheable",        :default => false
    t.boolean  "usable_for_optimizer", :default => false
  end

  create_table "gqueries_gquery_groups", :id => false, :force => true do |t|
    t.string "gquery_id"
    t.string "gquery_group_id"
  end

  create_table "gquery_groups", :force => true do |t|
    t.string   "group_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "graphs", :force => true do |t|
    t.integer  "blueprint_id"
    t.integer  "dataset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "graphs", ["dataset_id"], :name => "index_user_graphs_on_graph_data_id"

  create_table "groups", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key"
    t.string   "shortcut"
    t.integer  "group_id"
  end

  create_table "historic_serie_entries", :force => true do |t|
    t.integer  "historic_serie_id"
    t.integer  "year"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  add_index "input_elements", ["key"], :name => "unique api key", :unique => true
  add_index "input_elements", ["slide_id"], :name => "index_input_elements_on_slide_id"

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
  end

  create_table "link_datas", :force => true do |t|
    t.integer  "link_type",  :default => 0
    t.float    "share"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dataset_id"
    t.integer  "link_id"
  end

  add_index "link_datas", ["dataset_id"], :name => "index_link_datas_on_graph_data_id"

  create_table "links", :force => true do |t|
    t.integer "blueprint_id"
    t.integer "parent_id"
    t.integer "child_id"
    t.integer "carrier_id"
    t.integer "link_type"
  end

  add_index "links", ["blueprint_id"], :name => "index_links_on_blueprint_id"

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

  create_table "press_releases", :force => true do |t|
    t.string   "medium"
    t.string   "release_type"
    t.datetime "release_date"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  create_table "query_table_cells", :force => true do |t|
    t.integer  "query_table_id"
    t.integer  "row"
    t.integer  "column"
    t.string   "name"
    t.text     "gquery"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "query_tables", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "row_count"
    t.integer  "column_count"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "slot_datas", :force => true do |t|
    t.integer "dataset_id"
    t.integer "slot_id"
    t.float   "conversion"
    t.boolean "dynamic"
  end

  add_index "slot_datas", ["dataset_id"], :name => "index_slot_datas_on_graph_data_id"

  create_table "slots", :force => true do |t|
    t.integer "blueprint_id"
    t.integer "converter_id"
    t.integer "carrier_id"
    t.integer "direction"
  end

  add_index "slots", ["blueprint_id"], :name => "index_slots_on_blueprint_id"

  create_table "tabs", :force => true do |t|
    t.string "key"
    t.string "nl_vimeo_id"
    t.string "en_vimeo_id"
  end

  create_table "time_curve_entries", :force => true do |t|
    t.integer  "graph_id"
    t.integer  "converter_id"
    t.integer  "year"
    t.float    "value"
    t.string   "value_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "time_curve_entries", ["graph_id"], :name => "index_time_curve_entries_on_graph_id"

  create_table "translations", :force => true do |t|
    t.string   "key"
    t.text     "content_en"
    t.text     "content_nl"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

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
