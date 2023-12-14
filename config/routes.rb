# frozen_string_literal: true

Rails.application.routes.draw do
  mount Identity::Engine => '/auth'

  root to: 'pages#root'
  post '/' => 'pages#root'

  get 'gql/search'

  get '/texts/:id' => 'texts#show'

  get '/descriptions/charts/:id' => 'descriptions#charts'

  resources :password_resets, only: %i[new create edit update]

  resources :areas, only: %i[index show]

  # Old partner paths.
  get '/partners/:id', to: redirect("#{Partner::REMOTE_URL}/partners/%{id}")
  get '/partners',     to: redirect("#{Partner::REMOTE_URL}/partners")

  resources :dashboard_items, only: :show

  resource :settings, only: %i[edit update]

  get '/settings/dashboard',        to: 'settings#dashboard'
  put '/settings/dashboard',        to: 'settings#update_dashboard'
  put '/settings/hide_results_tip', to: 'settings#hide_results_tip'

  get '/user/account_deleted', to: 'pages#account_deleted'

  get '/survey', to: 'survey#show'
  put '/survey/:question', to: 'survey#answer_question'

  namespace :admin do
    root to: 'pages#index'
    get 'map', to: 'pages#map', as: :map
    post 'clear_cache' => 'pages#clear_cache', as: :clear_cache
    get 'surveys', to: 'pages#surveys', as: :surveys

    resources :general_user_notifications

    resources :texts, except: [:show]
  end

  resources :scenarios, except: [:new, :edit] do
    collection do
      post :load
      get :compare
      post :merge

      get  :weighted_merge
      post 'weighted_merge' => :perform_weighted_merge
    end

    member do
      get :load
      get :uncouple
      get :confirm_uncouple
      get 'energy_mix' => 'energy_mix#show'
      # legacy name for the energy mix
      get 'factsheet', to: redirect('scenarios/%{id}/energy_mix')

      get  'export'                => 'export_scenario#index'
      post 'export/esdl'           => 'export_scenario#esdl'
      get  'export/mondaine_drive' => 'export_scenario#mondaine_drive'
    end
  end

  resources :saved_scenarios, except: %i[new] do
    resource :feature, only: %i[show create update destroy], controller: 'featured_scenarios'

    resources :users, controller: 'saved_scenario_users' do
      member do
        get :confirm_destroy
      end
    end

    resources :versions, controller: 'saved_scenario_versions' do
      member do
        get :new
        post :create
        get :load
        get :revert
      end
    end

    member do
      get :load
      put :discard
      put :undiscard
      put :publish
      put :unpublish
    end

    collection do
      get :discarded
      get :all
    end

    get '/report/:report_name' => 'saved_scenario_reports#show'
  end

  get '/scenarios/:scenario_id/save', to: 'saved_scenarios#new', as: :new_saved_scenario

  get '/scenario/new' => 'scenarios#new'
  get '/scenario/reset' => 'scenarios#reset'
  get '/scenario/confirm_reset' => 'scenarios#confirm_reset'
  get '/scenario/grid_investment_needed' => 'scenarios#grid_investment_needed'

  get '/passthru/:id/*rest' => 'api_passthru#passthru',
    constraints: { rest: /.*/ },
    as: :api_passthru

  get '/scenario/reports/auto' => 'reports#auto'
  get '/scenario/reports/:id' => 'reports#show',
      constraints: { id: /[0-9a-z-]+/ }, as: :report

  get '/scenario/myc/:id' => 'scenarios#play_multi_year_charts'
  get '/scenario/:id/resume' => 'scenarios#resume'

  # This is the main action
  get '/scenario(/:tab(/:sidebar(/:slide)))' => 'scenarios#play', as: :play

  resources :output_elements, param: :key, only: %i[index show] do
    member do
      get :zoom
    end

    collection do
      get 'batch/:keys',    action: :batch
    end
  end

  get '/input_elements/by_slide' => 'input_elements#by_slide'

  match '/ete(/*url)',       to: 'api_proxy#default', via: :all
  match '/ete_proxy(/*url)', to: 'api_proxy#default', via: :all

  get '/show_all_countries'           => 'pages#show_all_countries'
  get '/show_flanders'                => 'pages#show_flanders'
  put '/set_locale(/:locale)'         => 'pages#set_locale', as: :set_locale
  get '/unsupported-browser'          => 'pages#unsupported_browser', as: :unsupported_browser
  get '/update_footer'                => 'pages#update_footer'
  get '/regions/:dataset_locale'      => 'pages#dataset', as: :region

  get '/contact'                      => 'contact#index', as: :contact
  post '/contact'                     => 'contact#send_message'

  get '/about'                        => 'content#about', as: :about
  get '/development'                  => 'content#development', as: :development
  get '/privacy-policy'               => 'content#privacy_statement', as: :privacy_statement
  get '/terms-of-service'             => 'content#terms_of_service', as: :terms_of_service
  get '/whats-new'                    => 'content#whats_new', as: :whats_new

  get '/local-global' => 'compare#index', as: :local_global
  get '/local-global/:ids' => 'compare#show', as: :local_global_scenarios

  resources :multi_year_charts, except: %i[new show edit update] do
    member do
      put :discard
      put :undiscard
    end

    collection do
      get :discarded
      get :list
    end
  end

  get '/import_esdl'  => 'import_esdl#index'
  post '/import_esdl/create' => 'import_esdl#create', as: :import_esdl_create
  get '/esdl_suite/login' => 'esdl_suite#login'
  get '/esdl_suite/redirect' => 'esdl_suite#redirect'
  get '/esdl_suite/browse' => 'esdl_suite#browse'

  namespace :embeds do
    resource :pico, only: [:show]
  end

  # Incoming webhooks
  get '/incoming_webhooks/verify' => 'incoming_webhooks#verify'

  # Routes for the API. Typically used by ETEngine.
  namespace :api, path: '/api/v1' do
    put '/user'    => 'user#update'
    delete '/user' => 'user#destroy'

    resources :saved_scenarios, only: %i[index show create update destroy] do
      resources :users, only: %i[index create update destroy], controller: 'saved_scenario_users' do
        collection do
          post :create
          put :update
          delete :destroy
        end
      end

      resources :versions, only: %i[index show create update], controller: 'saved_scenario_versions' do
        member do
          get :revert
        end
      end
    end
  end

  %w[404 422 500].each do |code|
    get "/#{code}", to: 'errors#show', code: code
  end
end
