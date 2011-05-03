#
# Special controller for the event: 
# Gasterra Transition Year Price
#
class TransitionPriceController < ApplicationController
  layout 'pages'
  

  # If something is posted to this page, redirect it to the intro page.
  #
  # GET /index - shows landing page
  # POST /index - starts a new scenario and redirects to intro page
  #
  # @tested 2010-12-21 jape
  #
  def index
    @user_session = UserSession.new
  end
  
  # 
  # The intro page.
  # GET /intro - shows form with creation an of account.
  # POST /intro - creates an account for a user, loads the scenario, redirects it.
  #
  # @tested 2010-12-21 jape
  #
  def intro    
    if !(request.post? && !params[:user].nil?)
      @user = User.new
    else
      @user = User.new(params[:user])
      if @user.save
        flash[:notice] = I18n.t("flash.register")
        redirect_to(:action => 'load_scenario', :redirect_to => transition_price_intro_path(:step => '2')) and return
        
        # redirect_to()
      else
        render :action => "intro"
      end  
    end
  end
  
  # The second intro page.
  # GET /intro/2 - shows a page with some extra information.
  #
  # @tested 2010-12-21 jape
  #
  def intro_2
  end
  
  
  # Logs the user in and loads the predefined scenario
  # POST /login_and_load_scenario - tries to login and tries to load first scenario,if unsuccesfull, redirect back.
  #
  # @tested 2010-12-21 jape
  #
  def login_and_load_scenario
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
      if result
        flash[:notice] = I18n.t("flash.login")
        #load_scenario_for_user(@user_session.user)
        redirect_to :action => 'load_scenario'
      else
        flash[:error] = I18n.t("flash.invalid_login")
        redirect_to :action => "index"
      end
    end  
  end
  
  # Load a transition price scenario for the current user and creates one if it doesn't exist..
  # GET /transition_price/load_scenario
  #
  # @tested 2010-12-21 jape
  #
  def load_scenario
    scenario = current_user.scenarios.by_type(:transition_price).first
    
    if scenario.nil?
      preset = find_transition_price_preset
      raise HTTPStatus::Forbidden.new("A preset scenario need to be created with as scenariotype: transition_price_preset") if preset.nil?
      scenario = current_user.scenarios.create( :title => preset.title, :preset_scenario_id => preset.id, :preset_scenario => preset, :scenario_type => Scenario::TRANSITION_PRICE_TYPE)
    end
    
    redirect_to load_scenario_path(:id => scenario.id ,:redirect_to => transition_price_intro_path(:step => '2'))
  end


  
  private 
  
  #
  # Finds the transition price preset
  #
  # NOTE: Make sure this scenario exists in the database.
  #
  def find_transition_price_preset
    Scenario.by_type('transition_price_preset').first
  end


end
