class ScenariosController < ApplicationController
  layout 'pages'

  before_filter :ensure_valid_browser
  before_filter :find_scenario, :only => [:show, :load]
  before_filter :require_user, :only => [:index, :new]

  def index
    if current_user.admin?
      @current_page = (params[:page] || 1).to_i
      @scenarios = Api::Scenario.all(:params => { :page => @current_page})
    else
      @scenarios = current_user.saved_scenarios.order("created_at DESC")
      @scenarios = @scenarios.map(&:scenario).compact
    end
  end

  def show
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
  def create
    @scenario = Api::Scenario.create(params[:saved_scenario])
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
