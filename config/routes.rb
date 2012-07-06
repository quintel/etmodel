Etm::Application.routes.draw do

  get "gql/search"

  root :to => 'pages#choose'

  match '/choose' => 'pages#choose'
  match '/pro' => 'pages#root', :as => :home

  match '/demand/intro'       => 'tab#intro'
  match '/demand(/:sidebar)'  => 'tab#show', :defaults => {:sidebar => 'households',     :tab => 'demand'}
  match '/costs(/:sidebar)'   => 'tab#show', :defaults => {:sidebar => 'combustion',     :tab => 'costs'}
  match '/targets(/:sidebar)' => 'tab#show', :defaults => {:sidebar => 'sustainability', :tab => 'targets'}
  match '/supply(/:sidebar)'  => 'tab#show', :defaults => {:sidebar => 'electricity',    :tab => 'supply'}
  match '/info/:ctrl/:act' => "tab#info", :as => :tab_info
  match "/:tab(/:sidebar)" => 'tab#show', :as => :tab, :constraints => {:tab => /(targets|demand|costs|supply)/}

  match '/texts/:id' => 'texts#show'
  # remove after updating hard coded urls in db
  match '/translations/:id' => 'texts#show'

  match 'login'  => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout

  resources :descriptions, :only => :show
  match '/descriptions/charts/:id'  => 'descriptions#charts'

  match 'track' => 'track#track', :as => :path

  resources :user_sessions, :users

  resources :partners, :only => [:show, :index]

  resources :constraints, :only => :show do
    get :iframe, :on => :member
  end

  resource :settings, :only => [:edit, :update]

  get '/settings/dashboard', :to => 'settings#dashboard'
  put '/settings/dashboard', :to => 'settings#update_dashboard'

  match '/search' => 'search#index', :as => :search

  namespace :admin do
    root :to => 'pages#index'
    match 'map', :to => 'pages#map', :as => :map
    match 'clear_cache' => 'pages#clear_cache', :as => :clear_cache

    resources :predictions,
              :input_elements,
              :year_values,
              :slides,
              :sidebar_items,
              :texts,
              :output_element_series,
              :converter_positions,
              :general_user_notifications,
              :constraints,
              :descriptions,
              :users,
              :partners
    resources :comments, :except => [:new, :create]
    resources :areas, :only => [:index, :show]

    resources :tabs, :except => :show do
      resources :sidebar_items
    end

    resources :sidebar_items do
      resources :slides
    end

    resources :slides do
      resources :input_elements
    end

    resources :gql do
      collection do
        get :search
      end
    end
    resources :press_releases do
      collection do
        post :upload
      end
    end
    resources :output_elements do
      get :all, :on => :collection
    end
  end

  resource :scenario, :except => [:edit, :update] do
    get :reset
    get :reset_to_preset
  end

  resources :scenarios, :except => [:edit, :update] do
    post :load, :on => :collection
    get :load, :on => :member
  end

  resources :output_elements, :only => [:index, :show] do
    collection do
      get :visible
      get :invisible
    end
  end

  resources :predictions, :only => [:index, :show] do
    member do
      post :comment
      get :share
    end
  end

  match '/converters/:input_element_id' => 'converters#show'
  match '/select_movie/:id'             => 'pages#select_movie'
  match '/units'                        => 'pages#units'
  match '/about'                        => 'pages#about'
  match '/feedback'                     => 'pages#feedback', :as => :feedback
  match '/tutorial/(:tab)(/:sidebar)'   => 'pages#tutorial', :as => :tutorial
  match '/pages/intro'                  => 'pages#intro', :as => :start
  match '/famous_users'                 => 'pages#famous_users'
  match '/press_releases'               => 'pages#press_releases'
  match '/optimize'                     => 'pages#optimize'
  match '/disclaimer'                   => 'pages#disclaimer'
  match '/privacy_statement'            => 'pages#privacy_statement'
  match '/show_all_countries'           => 'pages#show_all_countries'
  match '/show_flanders'                => 'pages#show_flanders'
  match '/municipalities'               => 'pages#municipalities'
  match '/careers'                      => 'pages#careers',     :as => :careers
  match '/sitemap'                      => 'pages#sitemap',     :as => :sitemap
  match '/information'                  => 'pages#information', :as => :information
  match '/bugs' => 'pages#bugs', :as => :bugs
  match '/set_locale(/:locale)' => 'pages#set_locale', :as => :set_locale

  match '/pages/flush_cache' => 'pages#flush_cache'

  match '/charts/topology' => 'charts#topology'
  match '/charts/sankey' => 'charts#sankey'

  match "/404", :to => "pages#404"
  match "/500", :to => "pages#500"

end
