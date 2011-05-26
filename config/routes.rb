Etm::Application.routes.draw do  
  root :to => 'pages#root'

  match '/costs/intro' => 'costs#intro'
  match '/costs(/:id)' => 'costs#show', :defaults => {:id => 'combustion'}

  match '/demand/intro' => 'demand#intro'
  match '/demand(/:id(/:slide))' => 'demand#show', :defaults => {:id => 'households'}


  match '/policy/intro' => 'policy#intro'
  match '/policy(/:id)' => 'policy#show', :defaults => {:id => 'sustainability'}

  match '/supply/intro' => 'supply#intro'
  match '/supply(/:id)' => 'supply#show', :defaults => {:id => 'electricity'}

  match '/local_supply/intro' => 'local_supply#intro'
  match '/local_supply(/:id)' => 'local_supply#show', :defaults => {:id => 'electricity_renewable'}

  match '/local_demand/intro' => 'local_demand#intro'
  match '/local_demand(/:id)' => 'local_demand#show', :defaults => {:id => 'electricity_renewable'}

  match '/national_supply/intro' => 'national_supply#intro'
  match '/national_supply(/:id)' => 'national_supply#show', :defaults => {:id => 'electricity'}
  
  match '/demographics/intro' => 'demographics#intro'
  match '/demographics(/:id)' => 'demographics#show', :defaults => {:id => 'households'}

  match '/descriptions/chart/:id'  => 'descriptions#show', :output => "OutputElement"
  match '/descriptions/serie/:id'  => 'descriptions#show', :output => "OutputElementSerie"
  match '/descriptions/slider/:id' => 'descriptions#show', :output => "InputElement"

  match '/descriptions/slider/:id' => 'descriptions#show', :output => "InputElement"
  
  match 'house_selections/tool'  => 'house_selections#tool',  :as => :house_selection_tool
  match 'house_selections/set'   => 'house_selections#set',   :as => :house_selection_set
  match 'house_selections/apply' => 'house_selections#apply', :as => :house_selection_apply
  match 'house_selections/clear' => 'house_selections#clear', :as => :house_selection_clear

  match 'login'  => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout

  resources :partners, :user_sessions, :users, :descriptions
  resources :constraints, :only => :show do
    get :iframe, :on => :member
  end
  resource :settings, :searches

  namespace :admin do
    root :to => 'pages#index'
    
    resources :areas,
              :expert_predictions, 
              :input_elements, 
              :year_values, 
              :tabs, 
              :slides, 
              :sidebar_items, 
              :translations, 
              :output_elements, 
              :output_element_series, 
              :press_releases, 
              :converter_positions,
              :view_nodes
  end

  resource :scenario do
    get :reset
    get :reset_to_preset
    put :change_complexity
  end
  
  resources :scenarios do
    collection do
      get :municipality
    end
    member do
      get :load
    end
  end

  resources :output_elements do
    collection do
      get :select
    end
  end

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
  match '/show_all_views'                  => 'pages#show_all_views'
  match '/municipalities'                  => 'pages#municipalities'

  match '/home'                            => 'pages#home',        :as => :home
  match '/careers'                         => 'pages#careers',     :as => :careers
  match '/sitemap'                         => 'pages#sitemap',     :as => :sitemap
  match '/information'                     => 'pages#information', :as => :information

  match '/:controller(/:action(/:id))'
end
