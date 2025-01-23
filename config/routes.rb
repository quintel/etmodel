# frozen_string_literal: true

Rails.application.routes.draw do
  mount Identity::Engine => '/auth'

  # Root
  root to: 'pages#root'
  post '/' => 'pages#root'

  get 'gql/search'

  # Single GET routes
  get '/texts/:id' => 'texts#show'
  get '/descriptions/charts/:id' => 'descriptions#charts'

  # Restricted routes
  resources :password_resets, only: %i[new create edit update]
  resources :areas, only: %i[index show]
  resources :dashboard_items, only: :show
  resource :settings, only: %i[edit update]

  # Settings custom routes
  get '/settings/dashboard', to: 'settings#dashboard'
  put '/settings/dashboard', to: 'settings#update_dashboard'
  put '/settings/hide_results_tip', to: 'settings#hide_results_tip'

  # Various standalone routes
  get '/user/account_deleted', to: 'pages#account_deleted'
  get '/survey',               to: 'survey#show'
  put '/survey/:question',     to: 'survey#answer_question'
  get '/my_etm/:page',         to: 'my_etm_passthru#set_cookie_and_redirect', as: :my_etm

  # Admin namespace
  namespace :admin do
    root to: 'pages#index'
    get 'map',         to: 'pages#map',         as: :map
    post 'clear_cache' => 'pages#clear_cache',  as: :clear_cache
    get 'surveys',     to: 'pages#surveys',     as: :surveys

    # Managing texts in admin (omits :show).
    resources :texts, except: [:show]
  end

  # Scenarios
  # except: [:new, :edit] => leaving index, create, show, update, destroy
  resources :scenarios, except: %i[new edit] do
    collection do
      post :load
      get  :compare
      post :merge

      get  :weighted_merge
      post 'weighted_merge' => :perform_weighted_merge
    end

    member do
      get  :load
      get  :coupling_settings
      post :update_couplings
      get  'energy_mix' => 'energy_mix#show'
      # Legacy name for the energy mix
      get  'factsheet', to: redirect('scenarios/%{id}/energy_mix')

      get  'export'                => 'export_scenario#index'
      post 'export/esdl'           => 'export_scenario#esdl'
      get  'export/mondaine_drive' => 'export_scenario#mondaine_drive'
    end
  end

  # Saved Scenarios
  resources :saved_scenarios, except: [] do
    resource :feature, only: %i[show create update destroy], controller: 'featured_scenarios'
    member do
      get  :load
      put  :discard
      put  :undiscard
      put  :publish
      put  :unpublish
      put  :restore
      get  :confirm_restore
    end

    collection do
      get :discarded
      get :all
    end

    get '/history'                 => 'saved_scenario_history#index'
    put '/history/:scenario_id'    => 'saved_scenario_history#update', as: :update_saved_scenario_history
    get '/report/:report_name'     => 'saved_scenario_reports#show'
  end

  # Multi-year charts
  get '/scenario_collection/:id', to: 'multi_year_charts#show', constraints: { id: /[0-9]+/ }, as: :show_multi_year_chart
  get '/scenario_collections',    to: 'multi_year_charts#list', as: :list_multi_year_charts
  get '/scenario_collection/new', to: 'multi_year_charts#new',  as: :new_multi_year_chart
  post '/scenario_collection/create', to: 'multi_year_charts#create_collection', as: :create_collection

  # Misc scenario routes
  get '/scenario/new'               => 'scenarios#new'
  get '/scenario/reset'             => 'scenarios#reset'
  get '/scenario/confirm_reset'     => 'scenarios#confirm_reset'
  get '/scenario/grid_investment_needed' => 'scenarios#grid_investment_needed'

  # Passthru
  get '/passthru/:id/*rest', to: 'api_passthru#passthru', constraints: { rest: /.*/ }, as: :api_passthru

  # Reports
  get '/scenario/reports/auto'           => 'reports#auto'
  get '/scenario/reports/:id'            => 'reports#show', constraints: { id: /[0-9a-z-]+/ }, as: :report
  get '/scenario/myc/:id'                => 'scenarios#play_multi_year_charts'
  get '/scenario/:id/resume'             => 'scenarios#resume'
  get '/scenario(/:tab(/:sidebar(/:slide)))' => 'scenarios#play', as: :play

  # Output elements
  resources :output_elements, param: :key, only: %i[index show] do
    member { get :zoom }
    collection { get 'batch/:keys', action: :batch }
  end

  get '/input_elements/by_slide' => 'input_elements#by_slide'

  # API proxy
  match '/ete(/*url)',       to: 'api_proxy#default', via: :all
  match '/ete_proxy(/*url)', to: 'api_proxy#default', via: :all

  # Misc pages
  get '/show_all_countries'  => 'pages#show_all_countries'
  get '/show_flanders'       => 'pages#show_flanders'
  put '/set_locale(/:locale)' => 'pages#set_locale', as: :set_locale
  get '/unsupported-browser' => 'pages#unsupported_browser', as: :unsupported_browser
  get '/update_footer'       => 'pages#update_footer'
  get '/regions/:dataset_locale', to: 'pages#dataset', as: :region

  # Contact
  get  '/contact' => 'contact#index', as: :contact
  post '/contact' => 'contact#send_message'

  # Info pages
  get '/about'          => 'content#about',          as: :about
  get '/development'    => 'content#development',    as: :development
  get '/privacy-policy' => 'content#privacy_statement', as: :privacy_statement
  get '/terms-of-service' => 'content#terms_of_service', as: :terms_of_service
  get '/whats-new'      => 'content#whats_new',      as: :whats_new

  # Local-global comparisons
  get '/local-global'      => 'compare#index', as: :local_global
  get '/local-global/:ids' => 'compare#show',  as: :local_global_scenarios

  get '/light' => 'light#index', as: :light

  # Multi-year charts
  resources :multi_year_charts, except: %i[new show edit update] do
    member do
      put :discard
      put :undiscard
    end

    collection do
      get :discarded
    end
  end

  # ESDL
  get  '/import_esdl'         => 'import_esdl#index'
  post '/import_esdl/create'  => 'import_esdl#create', as: :import_esdl_create
  get  '/esdl_suite/login'    => 'esdl_suite#login'
  get  '/esdl_suite/redirect' => 'esdl_suite#redirect'
  get  '/esdl_suite/browse'   => 'esdl_suite#browse'

  # Embeds namespace
  namespace :embeds do
    resource :pico, only: [:show]
  end

  # Incoming webhooks
  get '/incoming_webhooks/verify' => 'incoming_webhooks#verify'

  # API routes
  namespace :api, path: '/api/v1' do
    put '/user'    => 'user#update'
    delete '/user' => 'user#destroy'

    # Restrict to known actions
    resources :saved_scenarios, only: %i[index show create update destroy]

    resources :transition_paths, only: %i[index show create update destroy] # TODO: Re-route to a helpful error page
  end

  %w[404 422 500].each do |code|
    get "/#{code}", to: 'errors#show', code: code
  end
end
