class ScenariosController < ApplicationController
  before_filter :ensure_valid_browser
  before_filter :find_scenario, :only => [:show, :load]
  before_filter :require_user, :only => [:index, :new]

  def index
    if current_user.admin?
      @saved_scenarios = SavedScenario.page(params[:page]).per(15)
      @scenarios = @saved_scenarios.map{|s| s.scenario rescue nil}.compact
    else
      @saved_scenarios = current_user.saved_scenarios.order("created_at DESC")
      @scenarios = @scenarios.map(&:scenario).compact
    end
  end

  def show
    if(@scenario.nil?)
      redirect_to home_path, :notice => "Scenario not found" and return
    end
  end

  def new
    @saved_scenario = SavedScenario.new(
      :api_session_id => Current.setting.api_session_id
    )
  end

  def reset
    Current.setting.reset_scenario
    redirect_to_back
  end

  ##
  # Creates a scenario and saves the current settings into it.
  #
  # POST /scenarios/
  #
  # Set the protected flag to true. With API v3 we'll set the client app id
  # and the right user_id
  def create
    attrs = params[:saved_scenario].merge(:protected => true)
    @scenario = Api::Scenario.create(attrs)
    attributes = {:scenario_id => @scenario.id}
    @saved_scenario = current_user.saved_scenarios.create!(attributes)
    redirect_to scenarios_path
  end

  # Loads a scenario from a id.
  #
  # GET /scenarios/:id/load
  #
  def load
    if @scenario.nil?
      redirect_to start_path, :notice => "Scenario not found" and return
    end
    Current.setting = Setting.load_from_scenario(@scenario)
    # more logic could be added here, such as setting the round only if the
    # scenario name contains the "wattnu" string or something like that
    if wattnu? || @scenario.wattnu?
      Current.setting.current_round = 3
      session[:wattnu] = true
    end
    redirect_to start_path
  end

  private

    # Finds the scenario from id
    def find_scenario
      @scenario = Api::Scenario.find(params[:id])
    rescue ActiveResource::ResourceNotFound
      nil
    end
end
