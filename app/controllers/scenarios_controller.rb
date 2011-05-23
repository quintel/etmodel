class ScenariosController < ApplicationController
  layout 'etm'
  helper :all
  
  before_filter :ensure_valid_browser
  before_filter :set_scenario, :only => [:edit, :reset_to_preset, :update]
  before_filter :set_scenario_from_id, :only => :load


  def index
    unless current_user
      flash[:notice] = I18n.t("flash.need_login")
      redirect_to "/login?redirect_to=\/scenarios"
    else
      if current_user.role_id
        @scenarios = Scenario.exclude_api.order("created_at DESC")
      else
        @scenarios = current_user.scenarios.exclude_api.order("created_at DESC")
      end
    end
  end
 


  def show
    @scenario = Scenario.find(params[:id])
  end
  
  

  def new
    unless current_user
      flash[:notice] = I18n.t("flash.need_login")
      redirect_to "/login?redirect_to=\/scenarios"
    else
      @scenario = Scenario.new
      @scenario.description = get_constraint_description
    end
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
      @scenario.attachments.each { |x| @scenario.attachments.delete(x)  if x.new_record? && x.file_file_size.nil? }
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
    # @scenario.reload
    @scenario.attachments.reload
    new_attachments = @scenario.attachments.select {|x| x.new_record? }
    @scenario.attachments.build if new_attachments.size == 0
    raise HTTPStatus::Forbidden.new if (!current_user || @scenario.user.nil? || @scenario.user.id != current_user.id)
    @existing_attachments =  @scenario.attachments.select{|x| !x.new_record? }
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
  def set_scenario_from_id
    if params[:id] && params[:id] != 'current'
      @scenario = Scenario.find(params[:id])
      true
    else
      false
    end
  end
  
  
  # Makes a nice description out of the constraints.
  def get_constraint_description
    Current.view.root.constraints.map{|c| "#{c.name}: #{c.output.to_s.gsub(/<\/?[^>]*>/, "")}"}.join("\n")
  end

end

