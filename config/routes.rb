Etm::Application.routes.draw do
  root to: 'pages#root'
  post '/' => 'pages#root'

  get "gql/search"

  get '/scaled', to: 'pages#scaled'

  get '/choose' => 'pages#choose'

  get '/info/:ctrl/:act' => "pages#info", as: :tab_info

  get '/texts/:id' => 'texts#show'

  get 'login'  => 'user_sessions#new', as: :login
  get 'logout' => 'user_sessions#destroy', as: :logout

  resources :descriptions, only: :show
  get '/descriptions/charts/:id'  => 'descriptions#charts'

  resources :user_sessions
  resources :users, except: [:index, :show, :destroy]

  get '/users/:id/unsubscribe' => 'users#unsubscribe', as: :unsubscribe

  resource :user, only: [:edit, :update]
  resources :testing_grounds, only: [:create]

  # Old partner paths.
  get '/partners/:id', to: redirect("#{Partner::REMOTE_URL}/partners/%{id}")
  get '/partners',     to: redirect("#{Partner::REMOTE_URL}/partners")

  resources :constraints, only: :show

  resource :settings, only: [:edit, :update]

  get '/settings/dashboard', to: 'settings#dashboard'
  put '/settings/dashboard', to: 'settings#update_dashboard'

  namespace :admin do
    root to: 'pages#index'
    get 'map', to: 'pages#map', as: :map
    post 'clear_cache' => 'pages#clear_cache', as: :clear_cache

    resources :predictions,
              :sidebar_items,
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

  resources :scenarios, except: [:edit, :update] do
    collection do
      post :load
      get :compare
      post :merge

      get  :weighted_merge
      post :weighted_merge, to: :perform_weighted_merge
    end
    get :load, on: :member
  end

  get '/scenario/new' => 'scenarios#new'
  get '/scenario/reset' => 'scenarios#reset'
  get '/scenario/grid_investment_needed' => 'scenarios#grid_investment_needed'
  # This is the main action
  get '/scenario(/:tab(/:sidebar(/:slide)))' => 'scenarios#play', as: :play

  resources :output_elements, only: [:index, :show] do
    collection do
      get 'visible/:id',   action: :visible
      get 'invisible/:id', action: :invisible
    end

    get :zoom, on: :member
  end

  resources :predictions, only: [:index, :show] do
    member do
      get :share
    end
  end

  match '/ete(/*url)',       to: 'api_proxy#default', via: :all
  match '/ete_proxy(/*url)', to: 'api_proxy#default', via: :all

  get '/select_movie/:id'             => 'pages#select_movie', defaults: {format: :js}
  get '/units'                        => 'pages#units'
  get '/about'                        => 'pages#about'
  get '/feedback'                     => 'pages#feedback', as: :feedback
  get '/tutorial/(:tab)(/:sidebar)'   => 'pages#tutorial', as: :tutorial
  get '/prominent_users'              => 'pages#prominent_users'
  get '/disclaimer'                   => 'pages#disclaimer'
  get '/privacy_statement'            => 'pages#privacy_statement'
  get '/show_all_countries'           => 'pages#show_all_countries'
  get '/show_flanders'                => 'pages#show_flanders'
  get '/sitemap(.:format)'            => 'pages#sitemap', defaults: {format: :xml}
  get '/known_issues'                 => 'pages#bugs',        as: :bugs
  get '/quality_control'              => 'pages#quality', as: :quality
  put '/set_locale(/:locale)' => 'pages#set_locale', as: :set_locale
  get '/browser_support' => 'pages#browser_support'
  get '/update_footer'   => 'pages#update_footer'
  get '/regions/:dataset_locale' => 'pages#dataset', as: :region

  get "/404", to: "pages#404"
  get "/500", to: "pages#500"
end
