# frozen_string_literal: true

Etm::Application.routes.draw do
  root to: 'pages#root'
  post '/' => 'pages#root'

  get 'gql/search'

  get '/texts/:id' => 'texts#show'

  get 'login'  => 'user_sessions#new', as: :login
  get 'logout' => 'user_sessions#destroy', as: :logout

  get '/descriptions/charts/:id' => 'descriptions#charts'

  resources :user_sessions
  resources :users, except: %i[index show edit destroy]
  resources :password_resets, only: %i[new create edit update]

  resource :user, only: %i[edit update destroy] do
    post :confirm_delete, on: :member
  end

  # Old partner paths.
  get '/partners/:id', to: redirect("#{Partner::REMOTE_URL}/partners/%{id}")
  get '/partners',     to: redirect("#{Partner::REMOTE_URL}/partners")

  resources :dashboard_items, only: :show

  resource :settings, only: %i[edit update]

  get '/settings/dashboard',        to: 'settings#dashboard'
  put '/settings/dashboard',        to: 'settings#update_dashboard'
  put '/settings/hide_results_tip', to: 'settings#hide_results_tip'

  namespace :admin do
    root to: 'pages#index'
    get 'map', to: 'pages#map', as: :map
    post 'clear_cache' => 'pages#clear_cache', as: :clear_cache

    resources :general_user_notifications,
              :users

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
      get 'energy_mix' => 'energy_mix#show'
      # legacy name for the energy mix
      get 'factsheet', to: redirect('scenarios/%{id}/energy_mix')
    end
  end

  resources :saved_scenarios, except: %i[new destroy] do
    resource :feature, only: %i[show create update destroy], controller: 'featured_scenarios'

    member do
      get :load

      # get    'feature' => 'featured_scenarios#edit'
      # post   'feature' => 'featured_scenarios#create'
      # put    'feature' => 'featured_scenarios#update'
      # delete 'feature' => 'featured_scenarios#destroy'
    end

    get '/report/:report_name' => 'saved_scenario_reports#show'
  end

  get '/scenarios/:scenario_id/save', to: 'saved_scenarios#new', as: :new_saved_scenario

  get '/scenario/new' => 'scenarios#new'
  get '/scenario/reset' => 'scenarios#reset'
  get '/scenario/grid_investment_needed' => 'scenarios#grid_investment_needed'

  get '/scenario/reports/auto' => 'reports#auto'
  get '/scenario/reports/:id' => 'reports#show',
      constraints: { id: /[0-9a-z-]+/ }, as: :report

  # This is the main action
  get '/scenario/myc/:id' => 'scenarios#play_multi_year_charts'
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

  get '/units'                        => 'pages#units'
  get '/tutorial/(:tab)(/:sidebar)'   => 'pages#tutorial', as: :tutorial
  get '/disclaimer'                   => 'pages#disclaimer'
  get '/privacy_statement'            => 'pages#privacy_statement'
  get '/show_all_countries'           => 'pages#show_all_countries'
  get '/show_flanders'                => 'pages#show_flanders'
  get '/sitemap(.:format)'            => 'pages#sitemap', defaults: { format: :xml }
  get '/known_issues'                 => 'pages#bugs',        as: :bugs
  get '/quality_control'              => 'pages#quality', as: :quality
  get '/whats-new'                    => 'pages#whats_new', as: :whats_new
  put '/set_locale(/:locale)' => 'pages#set_locale', as: :set_locale
  get '/browser_support' => 'pages#browser_support'
  get '/update_footer'   => 'pages#update_footer'
  get '/regions/:dataset_locale' => 'pages#dataset', as: :region

  get '/local-global' => 'compare#index', as: :local_global
  get '/local-global/:ids' => 'compare#show', as: :local_global_scenarios

  resources :multi_year_charts, only: %i[index create destroy]

  get '/import_esdl' => 'import_esdl#index'
  post '/import_esdl' => 'import_esdl#create', as: :import_esdl_create

  namespace :embeds do
    resource :pico, only: [:show]
  end

  # Incoming webhooks
  get '/incoming_webhooks/mailchimp/:key'  => 'incoming_webhooks#verify'
  post '/incoming_webhooks/mailchimp/:key' => 'incoming_webhooks#mailchimp'

  %w[404 422 500].each do |code|
    get "/#{code}", to: 'errors#show', code: code
  end
end
