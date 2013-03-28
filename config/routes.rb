Etm::Application.routes.draw do

  get "gql/search"

  root :to => 'pages#choose'

  match '/choose' => 'pages#choose'
  match '/pro' => 'pages#root', :as => :home
  match '/info/:ctrl/:act' => "pages#info", :as => :tab_info

  match '/texts/:id' => 'texts#show'

  match 'login'  => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout

  resources :descriptions, :only => :show
  match '/descriptions/charts/:id'  => 'descriptions#charts'

  resources :user_sessions
  resources :users, :except => [:index, :show, :destroy]
  resource :user, :only => [:edit, :update]

  resources :partners, :only => [:show, :index]

  resources :constraints, :only => :show

  resource :settings, :only => [:edit, :update]

  get '/settings/dashboard', :to => 'settings#dashboard'
  put '/settings/dashboard', :to => 'settings#update_dashboard'

  match '/search' => 'search#index', :as => :search

  namespace :admin do
    root :to => 'pages#index'
    match 'map', :to => 'pages#map', :as => :map
    match 'clear_cache' => 'pages#clear_cache', :as => :clear_cache

    resources :predictions,
              :sidebar_items,
              :output_elements,
              :output_element_series,
              :general_user_notifications,
              :constraints,
              :users,
              :partners

    resources :comments, :except => [:new, :create]
    resources :texts, :except => [:show]
    resources :areas, :only => [:index, :show]

    resources :tabs do
      resources :sidebar_items
    end

    resources :sidebar_items do
      resources :slides
    end

    resources :slides, :except => :show do
      resources :input_elements
    end

    resources :gql do
      collection do
        get :search
      end
    end
    resources :press_releases, :except => :show do
      collection do
        post :upload
      end
    end

    resources :input_elements, :except => :show
  end

  resources :scenarios, :except => [:edit, :update] do
    collection do
      post :load
      get :compare
      post :merge
    end
    get :load, :on => :member
  end

  match '/scenario/new' => 'scenarios#new'
  match '/scenario/reset' => 'scenarios#reset'
  match '/scenario/grid_investment_needed' => 'scenarios#grid_investment_needed'
  # This is the main action
  match '/scenario(/:tab(/:sidebar(/:slide)))' => 'scenarios#play', :as => :play

  resources :output_elements, :only => [:index, :show] do
    collection do
      get :visible
      get :invisible
    end
    get :zoom, :on => :member
  end

  resources :predictions, :only => [:index, :show] do
    member do
      post :comment
      get :share
    end
  end

  match '/ete(/*url)' => 'api_proxy#default'
  match '/ete_proxy(/*url)' => 'api_proxy#default'

  match '/select_movie/:id'             => 'pages#select_movie', :defaults => {:format => :js}
  match '/units'                        => 'pages#units'
  match '/about'                        => 'pages#about'
  match '/feedback'                     => 'pages#feedback', :as => :feedback
  match '/tutorial/(:tab)(/:sidebar)'   => 'pages#tutorial', :as => :tutorial
  match '/famous_users'                 => 'pages#famous_users'
  match '/press_releases'               => 'pages#press_releases'
  match '/disclaimer'                   => 'pages#disclaimer'
  match '/privacy_statement'            => 'pages#privacy_statement'
  match '/show_all_countries'           => 'pages#show_all_countries'
  match '/show_flanders'                => 'pages#show_flanders'
  match '/sitemap(.:format)'            => 'pages#sitemap', :defaults => {:format => :xml}
  match '/known_issues'                 => 'pages#bugs',        :as => :bugs
  match '/quality_control'              => 'pages#quality', :as => :quality
  match '/set_locale(/:locale)' => 'pages#set_locale', :as => :set_locale
  match '/browser_support' => 'pages#browser_support'
  match '/update_footer'   => 'pages#update_footer'

  match "/404", :to => "pages#404"
  match "/500", :to => "pages#500"
end
