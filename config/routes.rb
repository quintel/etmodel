Etm::Application.routes.draw do
  root to: 'pages#root'
  post '/' => 'pages#root'

  get "gql/search"

  get '/scaled', to: 'pages#scaled'

  get '/info/:ctrl/:act' => "pages#info", as: :tab_info

  get '/texts/:id' => 'texts#show'

  get 'login'  => 'user_sessions#new', as: :login
  get 'logout' => 'user_sessions#destroy', as: :logout

  resources :descriptions, only: :show
  get '/descriptions/charts/:id'  => 'descriptions#charts'

  resources :user_sessions
  resources :users, except: [:index, :show, :edit, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]

  get '/users/:id/unsubscribe' => 'users#unsubscribe', as: :unsubscribe

  resource :user, only: [:edit, :update, :destroy] do
    post :confirm_delete, on: :member
  end

  resources :testing_grounds, only: [:create]

  # Old partner paths.
  get '/partners/:id', to: redirect("#{Partner::REMOTE_URL}/partners/%{id}")
  get '/partners',     to: redirect("#{Partner::REMOTE_URL}/partners")

  resources :constraints, only: :show

  resource :settings, only: [:edit, :update]

  get '/settings/dashboard',        to: 'settings#dashboard'
  put '/settings/dashboard',        to: 'settings#update_dashboard'
  put '/settings/hide_results_tip', to: 'settings#hide_results_tip'

  namespace :admin do
    root to: 'pages#index'
    get 'map', to: 'pages#map', as: :map
    post 'clear_cache' => 'pages#clear_cache', as: :clear_cache

    resources :sidebar_items,
              :output_elements,
              :output_element_series,
              :general_user_notifications,
              :constraints,
              :users

    resources :texts, except: [:show]
    resources :areas, only: [:index, :show]

    resources :tabs do
      resources :sidebar_items
    end

    resources :sidebar_items do
      resources :slides
    end

    resources :slides, except: :show do
      resources :input_elements
    end

    resources :gql do
      collection do
        get :search
      end
    end

    resources :input_elements, except: :show
  end

  resources :scenarios, except: [:edit] do
    collection do
      post :load
      get :compare
      post :merge

      get  :weighted_merge
      post 'weighted_merge' => :perform_weighted_merge
    end

    member do
      get :load
      get 'factsheet' => 'factsheets#show'
    end
  end

  resources :saved_scenarios, only:[:show] do
    member { get :load }
  end

  get '/scenario/new' => 'scenarios#new'
  get '/scenario/reset' => 'scenarios#reset'
  get '/scenario/grid_investment_needed' => 'scenarios#grid_investment_needed'

  get '/scenario/reports/auto' => 'reports#auto'
  get '/scenario/reports/:id' => 'reports#show',
    constraints: { id: /[0-9a-z-]+/ }, as: :report

  # This is the main action
  get '/scenario/myc/:id' => 'scenarios#play_multi_year_charts'
  get '/scenario(/:tab(/:sidebar(/:slide)))' => 'scenarios#play', as: :play

  resources :output_elements, only: [:index, :show] do
    collection do
      get 'visible/:id',   action: :visible
      get 'invisible/:id', action: :invisible
      get 'batch/:ids',    action: :batch
    end

    get :zoom, on: :member
  end

  get '/input_elements/by_slide' => 'input_elements#by_slide'

  match '/ete(/*url)',       to: 'api_proxy#default', via: :all
  match '/ete_proxy(/*url)', to: 'api_proxy#default', via: :all

  get '/units'                        => 'pages#units'
  get '/feedback'                     => 'pages#feedback', as: :feedback
  post '/feedback'                    => 'pages#feedback'
  get '/tutorial/(:tab)(/:sidebar)'   => 'pages#tutorial', as: :tutorial
  get '/disclaimer'                   => 'pages#disclaimer'
  get '/privacy_statement'            => 'pages#privacy_statement'
  get '/show_all_countries'           => 'pages#show_all_countries'
  get '/show_flanders'                => 'pages#show_flanders'
  get '/sitemap(.:format)'            => 'pages#sitemap', defaults: {format: :xml}
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

  namespace :embeds do
    resource :pico, only: [:show]
  end

  %w[404 422 500].each do |code|
    get "/#{ code }", to: 'errors#show', code: code
  end
end
