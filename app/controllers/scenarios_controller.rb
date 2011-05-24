class ScenariosController < ApplicationController
  layout 'etm'
  helper :all
  
  before_filter :ensure_valid_browser
  before_filter :set_scenario, :only => [:edit, :reset_to_preset, :update]
  before_filter :find_scenario, :only => :load
  before_filter :require_user, :only => [:index, :new]

  def index
    if current_user.admin?
      @scenarios = Api::Scenario.all # TODO: add some kind of pagination
    else
      @scenarios = current_user.scenarios.exclude_api.order("created_at DESC")
    end
  end
 
  def show
    @scenario = Scenario.find(params[:id])
  end
  
  def new
    @saved_scenario = SavedScenario.new(
      :scenario_id => cookies[:api_session_id]
    )
  end

  ##
  # Creates a scenario and saves the current settings into it. 
  # 
  # POST /scenarios/
  #
  # @tested 2010-12-22 jape
  #
  def create
    @scenario = current_user.scenarios.build(params[:scenario])
    @scenario.copy_scenario_state(Current.scenario)
    if @scenario.save
      flash[:notice] = "#{I18n.t("flash.scenario_saved")}:#{@scenario.title}"
      redirect_to scenarios_url
    else
      render :action => 'new'
    end
  end

  ##
  # Loads a scenario from a id. 
  # 
  # GET /scenarios/:id/load
  #
  # @tested 2010-12-22 jape
  #
  def load
    Current.scenario = @scenario
    redirect_to_if start_path
  end
  
  def change_complexity
    Current.setting.complexity = params[:scenario][:complexity]
    redirect_to :back
  end

  ##############################
  # Mixed resource methods
  # These methods can be used for both a singular as well as a plural resource.
  ##############################
  
  
  ##
  # Update is used for Current.scenario as well as params[:id].
  # 
  # PUT /scenarios/:id
  # PUT /scenario
  #
  # @tested 2010-12-22 jape
  #
  def update
    if request.put?
      flash[:notice] = t('flash.succesfully_saved')

      @scenario.attributes = params[:scenario]
      @scenario.copy_scenario_state(Current.scenario)
      @scenario.save
      redirect_to :back
    end
  end
  
  
  ##
  # Edit the current scenario.
  #
  # GET /scenarios/:id/edit
  # GET /scenario/edit
  #  
  # @tested 2010-12-22 jape
  #
  def edit
    raise HTTPStatus::Forbidden.new if (!current_user || @scenario.user.nil? || @scenario.user.id != current_user.id)
  end
  
  ##############################
  # Singular resource methods
  # These are  methods that are invoked on Current.scenario
  ##############################


  ##
  # Resets the current scenario to it's default values
  #
  # GET /scenario/reset
  #
  # @untested 2010-12-27 seb
  #
  def reset
    begin
      Current.scenario.reset!
      flash[:notice] = I18n.t("flash.reset")
      redirect_to :back
    rescue ActionController::RedirectBackError => e
      logger.debug "No HTTP Referer was set, so not reverting back."
      render :text => "Ok reset, no HTTP_REFERER found."
    end
  end

  ##
  # Resets the current scenario to it's preset scenario.
  #
  # POST /scenario/reset_to_preset
  #
  # @tested 2010-12-21 jaap
  #
  def reset_to_preset
    raise HTTPStatus::Forbidden if @scenario.preset_scenario.nil?
    Current.reset_to_default!
    @scenario.copy_scenario_state(@scenario.preset_scenario)
    @scenario.save
    Current.scenario = @scenario

    redirect_to :back
  end
  
  private
  
    # Finds the scenario from id, or from the Current.scenario.
    def set_scenario
      @scenario = Current.scenario  if !(set_scenario_from_id)
    end

    # Finds the scenario from id
    def find_scenario
      @scenario = Scenario.find(params[:id])
    end  
end
