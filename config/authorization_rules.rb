authorization do

  role :guest do
    # has_permission_on [:pages], :to => [:browser_support,:root,:sitemap,:information,:intro]
    # has_permission_on [:demand], :to => [:agriculture,:households,:industy,:intro,:other,:overview,:transport]
    # has_permission_on [:query], :to => [:reset,:update,:page_update_block_graph,:update_slide]
    # has_permission_on [:policy], :to => [:index,:new,:create,:edit,:update]
    # has_permission_on [:pages], :to => [:index,:new,:create,:edit,:update]
    # has_permission_on [:costs], :to => [:index,:new,:create,:edit,:update]
    # has_permission_on [:suppy], :to => [:index,:new,:create,:edit,:update]
    # has_permission_on :articles, :to => [:index, :show]
    # has_permission_on :comments, :to => [:new, :create]
  end

  role :user do
    includes :guest
    # has_permission_on :articles, :to => [:new, :create]
  end

  role :manager do
    # includes :guest
    # has_permission_on :story_line, :to => [:edit, :update] do
    #   if_attribute :user => is { user }
    # end
  end

  role :admin do
    # admin start screen
    has_permission_on [:pages], :to => [:admin, :root, :intro, :browser_support, :disable_browser_check, :enable_browser_check]
    has_permission_on [:game_games], :to => [:index]    
    has_permission_on [:admin_optimize], :to => [:optimize]
    
    has_permission_on [:admin_groups], :to => [:manage,:find_model]
    has_permission_on [:admin_blueprint_converters], :to => [:manage,:find_model]
    has_permission_on [:admin_blueprints], :to => [:manage, :graph, :find_model]
    has_permission_on [:admin_converter_positions], :to => [:manage,:find_model]

    has_permission_on [:admin_areas], :to => [:manage,:find_model]
    has_permission_on [:admin_areagroups], :to => [:manage,:find_model]
    has_permission_on [:admin_carriers], :to => [:manage,:find_model]
    has_permission_on [:admin_carrier_datas], :to => [:manage,:find_model,:update_by_areagroup]
    has_permission_on [:admin_blackboxes], :to => [:manage, :rspec]
    has_permission_on [:admin_blackbox_scenarios], :to => :manage
    has_permission_on [:admin_converters], :to => [:manage,:find_converter]
    has_permission_on [:admin_converter_datas], :to => [:manage,:find_converter]
    has_permission_on [:admin_descriptions], :to => :manage
    has_permission_on [:admin_translations], :to => :manage
    has_permission_on [:admin_gqueries], :to => [:dump, :manage,:find_model,:test,:result]
    has_permission_on [:admin_graphs], :to => [:manage,:chart, :check,:import, :groups, :find_graph]
    has_permission_on [:admin_input_elements], :to => [:manage,:find_model]
    has_permission_on [:admin_slides], :to => [:manage,:find_model]
    has_permission_on [:admin_sidebar_items], :to => [:manage,:find_model]
    has_permission_on [:admin_tabs], :to => [:manage,:find_model]
    has_permission_on [:admin_output_element_series], :to => [:manage,:find_model]
    has_permission_on [:admin_output_elements], :to => [:manage,:find_model]    
    has_permission_on [:admin_historic_series], :to => [:manage,:find_model]
    has_permission_on [:admin_press_releases], :to => [:manage,:upload]
    has_permission_on [:admin_year_values], :to => [:manage,:find_model]
    has_permission_on [:admin_expert_predictions], :to => [:manage,:find_model]
    has_permission_on [:admin_user_logs], :to => [:manage,:find_model]
    has_permission_on [:admin_optimize], :to => [:manage,:update_slide ,:update_slide_remainder ,:restor_slide ,:update_qguery ,:qguery_procent ,:share_group ,:update_constraints_after_loop ,:create_policy ,:calibrate_step_value, :test_calibration, :new_calibration]

    has_permission_on [:admin_query_tables], :to => [:manage]
    has_permission_on [:admin_query_table_cells], :to => [:manage]

    has_permission_on [:optimizer_optimizers], :to => [:manage]
    has_permission_on [:optimizer_optimizer_steps], :to => [:manage]

    has_permission_on [:admin_view_nodes], :to => [:manage]
    has_permission_on [:admin_gql_test_cases], :to => [:manage]


    has_permission_on [:data_data], :to => [:manage, :find_model, :start, :redirect]
    has_permission_on [:data_converters], :to => [:manage, :find_model]
    has_permission_on [:data_converter_datas], :to => [:manage, :find_model]
    has_permission_on [:data_carriers], :to => [:manage, :find_model]
    has_permission_on [:data_carrier_datas], :to => [:manage, :find_model]
    has_permission_on [:data_areas], :to => [:manage, :find_model]
    has_permission_on [:data_graph], :to => [:manage, :find_model]
    has_permission_on [:data_graphs], :to => [:manage, :find_model]
  end
end

privileges do
  privilege :manage do
    includes :index,:show, :groups, :edit, :destroy, :update,:create, :read, :delete, :new, :find_model
  end
end
