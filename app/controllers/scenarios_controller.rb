class ScenariosController < ApplicationController
  before_filter :ensure_valid_browser
  before_filter :find_scenario, :only => [:show, :load]
  before_filter :require_user, :only => [:index, :new]
  before_filter :load_interface,
                :store_last_etm_page,
                :load_constraints, :only => :play

  def index
    items = if current_user.admin?
      SavedScenario.scoped
    else
      current_user.saved_scenarios
    end
    @saved_scenarios = items.order("created_at DESC").page(params[:page]).per(15)
    @scenarios = @saved_scenarios.map{|s| s.scenario rescue nil}.compact
  end

  def show
    if @scenario.nil?
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

  # Saves a scenario. This implies two db records: a saved_scenario in the ETM
  # and a proper scenario in the ETE. The ETM just stores the user_id and
  # scenario_id.
  #
  # POST /scenarios/
  #
  # Set the protected flag to true. The scenario_id parameter is critical: it
  # tells ETE to create a *copy* of the current scenario. Check in the engine
  # the Scenario#scenario_id= method to see what's going on.
  def create
    scenario_id = params[:saved_scenario].delete(:api_session_id)
    attrs = params[:saved_scenario].merge(
      :protected => true,
      :source => 'ETM',
      :scenario_id => scenario_id
    )
    begin
      @scenario = Api::Scenario.create(attrs)
      # Setting a fake title because the object validates its presence - the
      # engine scenarios table actually saves it
      @saved_scenario = current_user.saved_scenarios.create!(
        {:scenario_id => @scenario.id, :title => '_'})
      redirect_to scenarios_path
    rescue
      @saved_scenario = SavedScenario.new(
        :api_session_id => scenario_id
      )
      render :new
    end
  end

  # Loads a scenario from a id.
  #
  # GET /scenarios/:id/load
  #
  def load
    if @scenario.nil?
      redirect_to play_path, :notice => "Scenario not found" and return
    end
    session[:dashboard] = nil
    Current.setting = Setting.load_from_scenario(@scenario)
    redirect_to play_path
  end

  # GET /scenarios/grid_investment_needed
  def grid_investment_needed
    render :layout => false
  end

  # This is the main scenario action
  #
  def play
    @selected_slide_key = params[:slide] || @interface.current_slide.short_name
    respond_to do |format|
      format.html { render :layout => 'etm'}
      format.js
    end
  end

  private

    # Finds the scenario from id
    def find_scenario
      @scenario = Api::Scenario.find(params[:id], :params => {:detailed => true})
    rescue ActiveResource::ResourceNotFound
      nil
    end

    def load_interface
      tab = params[:tab] || 'demand'
      @interface = Interface.new(tab, params[:sidebar])

      # The JS app will take care of fetching a scenario id, in the meanwhile we
      # use this variable to show all the items in the top menu
      @active_scenario = true
    end

    def store_last_etm_page
      tab_key = @interface.current_tab.key
      sidebar_key = @interface.current_sidebar_item.key
      Current.setting.last_etm_page = url_for(controller: 'scenarios',
                                              action: 'play',
                                              anchor: "#{tab_key}/#{sidebar_key}")
    end

    def load_constraints
      dash = session[:dashboard]

      @constraints = if dash and dash.any?
        Constraint.for_dashboard(dash)
      else
        Constraint.default.ordered
      end
    end
end
