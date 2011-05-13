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
  match 'house_selections/set_element/:id' => 'house_selections#set_element'

  match 'login'  => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout

  match 'view_nodes/new/:node_type' => 'view_nodes#new'
  
  resources :areas, :partners, :input_elements, :user_sessions, :users, :constraints, :descriptions, :translations

  resource :settings, :searches

  namespace :admin do
    root :to => 'pages#index'
    
    resources :areas,
              :expert_predictions, 
              :input_elements, 
              :historic_series, 
              :year_values, 
              :tabs, 
              :slides, 
              :sidebar_items, 
              :descriptions, 
              :translations, 
              :output_elements, 
              :output_element_series, 
              :query_tables, 
              :query_table_cells, 
              :press_releases, 
              :converter_positions,
              :view_nodes

    resources :blackboxes do
      get :rspec, :on => :member
    end
    resources :graphs do
      collection do
        post :import
      end
      resources :converters
      resources :converter_datas
      collection do
        post :import
      end
    end
    resources :gqueries do
      get :result, :on => :member
      collection do
        get :dump
        post :dump
        get :test
        post :test
        get :result
      end
    end
  end

  resource :scenario do
    get :reset
    get :reset_to_preset
    put :change_complexity
  end
  
  resources :scenarios do
    resources :attachments
    
    collection do
      get :municipality
    end
    member do
      get :load
    end
  end

  namespace :optimizer do
    resources :optimizers
  end

# TODO rails 3
  resources :output_elements do
    collection do
      get :select
    end
  end

  match 'query/update/:output/' => 'query#update', :value => /[-0-9]+(?:\.[-0-9]*)?/
  #match 'query/reset' => 'query#reset', :as => :reset_scenario

  match '/select_movie/:id' => 'pages#select_movie'
  match '/units' => 'pages#units'
  match '/about' => 'pages#about'
  match '/feedback' => 'pages#feedback'
  match '/tutorial/(:section)(/:category)' => 'pages#tutorial'  
  match '/education' => 'pages#education'  
  match '/pages/intro' => 'pages#intro', :as => :start
  match '/testimonials' => 'pages#testimonials'
  match '/recommendations' => 'pages#recommendations'
  match '/press_releases' => 'pages#press_releases'
  match '/optimize' => 'pages#optimize'
  match '/disclaimer' => 'pages#disclaimer'
  match '/privacy_statement' => 'pages#privacy_statement'
  match '/show_all_countries' => 'pages#show_all_countries'
  match '/show_all_views' => 'pages#show_all_views'
  match '/municipalities' => 'pages#municipalities'
  match '/transitiejaarprijs' => 'transition_price#index', :as => :transition_price
  match '/transitiejaarprijs/intro/' => 'transition_price#intro', :as => :transition_price_intro
  match '/transitiejaarprijs/intro/(:step)' => 'transition_price#intro_2', :as => :transition_price_intro
  
  
  

  match '/home' => 'pages#home', :as => :home
  match '/careers' => 'pages#careers', :as => :careers
  match '/sitemap' => 'pages#sitemap', :as => :sitemap
  match '/information' => 'pages#information', :as => :information

  match '/:controller(/:action(/:id))'

end
