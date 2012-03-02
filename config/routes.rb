Etm::Application.routes.draw do

  get "gql/search"

  root :to => 'pages#root'

  match '/demand/intro' => 'demand#intro'

  match '/demand(/:id(/:slide))' => 'demand#show', :defaults => {:id => 'households'}
  match '/costs(/:id(/:slide))'  => 'costs#show', :defaults => {:id => 'combustion'}
  match '/policy(/:id(/:slide))' => 'policy#show', :defaults => {:id => 'sustainability'}
  match '/supply(/:id(/:slide))' => 'supply#show', :defaults => {:id => 'electricity'}

  match '/descriptions/chart/:id'  => 'descriptions#show'

  match '/translations/:id' => 'translations#show'

  match 'house_selections/tool'  => 'house_selections#tool',  :as => :house_selection_tool
  match 'house_selections/set'   => 'house_selections#set',   :as => :house_selection_set
  match 'house_selections/apply' => 'house_selections#apply', :as => :house_selection_apply
  match 'house_selections/clear' => 'house_selections#clear', :as => :house_selection_clear

  match 'login'  => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout

  resources :user_sessions, :users, :descriptions

  resources :partners, :only => [:show, :index]

  resources :constraints, :only => :show do
    get :iframe, :on => :member
  end

  resource :settings, :only => [:edit, :update]

  get '/settings/dashboard', :to => 'settings#dashboard'
  put '/settings/dashboard', :to => 'settings#update_dashboard'

  resource :searches

  namespace :admin do
    root :to => 'pages#index'

    match 'clear_cache' => 'pages#clear_cache', :as => :clear_cache

    resources :expert_predictions,
              :predictions,
              :input_elements,
              :year_values,
              :tabs,
              :slides,
              :sidebar_items,
              :translations,
              :output_element_series,
              :converter_positions,
              :interfaces,
              :general_user_notifications,
              :constraints,
              :descriptions,
              :users,
              :partners
    resources :comments, :except => [:new, :create]
    resources :areas, :only => [:index, :show]
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

  resource :scenario do
    get :reset
    get :reset_to_preset
    put :change_complexity
  end

  resources :scenarios do
    member do
      get :load
    end
  end

  resources :output_elements do
    collection do
      get :select
    end
  end

  resources :expert_predictions, :only => :index do
    collection do
      get :set
      get :reset
    end
  end

  resources :predictions, :only => [:index, :show] do
    member do
      post :comment
      get :share
    end
  end

  match '/converters/:input_element_id'    => 'converters#show'
  match '/select_movie/:id'                => 'pages#select_movie'
  match '/units'                           => 'pages#units'
  match '/about'                           => 'pages#about'
  match '/feedback'                        => 'pages#feedback'
  match '/tutorial/(:section)(/:category)' => 'pages#tutorial'
  match '/education'                       => 'pages#education'
  match '/pages/intro'                     => 'pages#intro', :as => :start
  match '/testimonials'                    => 'pages#testimonials'
  match '/recommendations'                 => 'pages#recommendations'
  match '/press_releases'                  => 'pages#press_releases'
  match '/optimize'                        => 'pages#optimize'
  match '/disclaimer'                      => 'pages#disclaimer'
  match '/privacy_statement'               => 'pages#privacy_statement'
  match '/show_all_countries'              => 'pages#show_all_countries'
  match '/show_flanders'                   => 'pages#show_flanders'
  match '/show_all_views'                  => 'pages#show_all_views'
  match '/wattnu'                          => 'pages#wattnu'
  match '/municipalities'                  => 'pages#municipalities'
  match '/home'                            => 'pages#home',        :as => :home
  match '/careers'                         => 'pages#careers',     :as => :careers
  match '/sitemap'                         => 'pages#sitemap',     :as => :sitemap
  match '/information'                     => 'pages#information', :as => :information

  match '/pages/flush_cache' => 'pages#flush_cache'

  # we should remove the catch-all route
  match '/:controller(/:action(/:id))'
end
