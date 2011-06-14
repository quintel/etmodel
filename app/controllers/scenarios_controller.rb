class ScenariosController < ApplicationController
  layout 'etm'
  helper :all

  before_filter :ensure_valid_browser
  before_filter :set_scenario, :only => [:edit, :reset_to_preset, :update]
  before_filter :find_scenario, :only => [:show]
  before_filter :require_user, :only => [:index, :new]

  # included here, so that we don't mess with the before_filter order
  include ApplicationController::HasDashboard


  def index
    if current_user.admin?
      @scenarios = Api::Scenario.all # TODO: add some kind of pagination
    else
      @scenarios = current_user.scenarios.exclude_api.order("created_at DESC")
    end
  end
 
  def show
  end
  
  def new
    @saved_scenario = SavedScenario.new(
      :api_session_key => Current.setting.api_session_key
    )
  end

  def reset
    Current.setting.reset_scenario
    redirect_to :back
  end

  ##
  # Creates a scenario and saves the current settings into it. 
  # 
  # POST /scenarios/
  #
  # @tested 2010-12-22 jape
  #
  def create
    @scenario = Api::Scenario.create(params[:saved_scenario])
    @saved_scenario = current_user.saved_scenarios.create(:scenario_id => @scenario.id)
    redirect_to scenarios_url
  end

  ##
  # Loads a scenario from a id. 
  # 
  # GET /scenarios/:id/load
  #
  # @tested 2010-12-22 jape
  #
  def load
    # TODO: Check if this is the correct behaviour.
    # when the user loads a predefined scenario or opens a scenario he's
    # been playing with on the mixer he has to work with a copy, right?
    # I have therefore added the clone parameter (which is handled on the ETE)
    # The Scenario life-cycle is convoluted - PZ Tue 31 May 2011 16:11:52 CEST
    @scenario = Api::Scenario.find(params[:id], :params => {:clone => true})
    settings = Setting::SCENARIO_ATTRIBUTES.inject({}) {|hsh,key| hsh.merge key => @scenario.send(key) }
    Current.setting = Setting.new(settings.merge(:scenario_id => @scenario.id));
    redirect_to start_path
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

  
  private
  
    # Finds the scenario from id, or from the Current.scenario.
    def set_scenario
      @scenario = Current.scenario  if !(set_scenario_from_id)
    end

    # Finds the scenario from id
    def find_scenario
      @scenario = Api::Scenario.find(params[:id])
    end  
end
