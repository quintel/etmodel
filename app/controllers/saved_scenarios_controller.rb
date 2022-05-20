# frozen_string_literal: true

# The controller that handles calls to the saved_scenario entity
class SavedScenariosController < ApplicationController
  before_action :assign_saved_scenario, only: %i[show load edit update discard undiscard destroy]
  before_action :assign_scenario, only: :load
  before_action :ensure_owner, only: %i[edit update discard undiscard destroy]
  helper_method :owned_saved_scenario?

  def index
    respond_to do |format|
      format.html do
        redirect_to scenarios_url
      end
      format.json do
        if current_user
          render json:
            SavedScenarioPresenter.new(
              current_user.saved_scenarios.custom_curves_order(
                Current.setting.end_year,
                Current.setting.area_code
              )
            )
        else
          render json: []
        end
      end
    end
  end

  def discarded
    @saved_scenarios = current_user.saved_scenarios.discarded
      .includes(:featured_scenario, :user)
      .order('updated_at DESC')
      .page(params[:page])
      .per(100)

    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html { @saved_scenario.loadable? ? render : redirect_to(root_path) }
      format.csv { @saved_scenario.loadable? ? render : render_not_found }
    end
  end

  # Shows a form for creating a new saved scenario.
  #
  # GET /scenarios/:scenario_id/save
  def new
    @saved_scenario = SavedScenario.new(
      scenario_id: params.require(:scenario_id),
      title: params[:title].presence
    )

    if params[:inline]
      render 'new', layout: false
    else
      render 'new'
    end
  end

  # Saves a scenario by creating a SavedScenario.
  #
  # This implies two DB records: a SavedSenario in the ETM and a Scenario in ETEngine. ETModel
  # stores the user_id,  scenario_id, and some other useful scenario metadata..
  #
  # POST /saved_scenarios
  def create
    ss_params = params.require(:saved_scenario).permit(:description, :title, :scenario_id)

    # Re-find the user, due to AssociationMismatch errors in development.
    result = CreateSavedScenario.call(ss_params[:scenario_id], current_user, ss_params)
    @saved_scenario = result.value

    if result.failure?
      @saved_scenario ||= SavedScenario.new(ss_params)
      render :new, status: :unprocessable_entity
      return
    end

    setting = Current.setting

    if setting.api_session_id == ss_params[:scenario_id].to_i
      setting.active_scenario_title = @saved_scenario.title
      setting.active_saved_scenario_id = @saved_scenario.id
    end

    redirect_to(setting.last_etm_page.presence || play_path)
  end

  def load
    scenario_attrs = { scenario_id: @saved_scenario.scenario_id }

    # Setting an active_saved_scenario enables saving a scenario. We only
    # do this for the owner of a scenario.
    Current.setting =
      Setting.load_from_scenario(
        @scenario,
        active_saved_scenario: {
          id: owned_saved_scenario? ? @saved_scenario.id : nil,
          title: @saved_scenario.localized_title(I18n.locale)
        }
      )

    new_scenario = Api::Scenario.create(scenario: { scenario: scenario_attrs })
    Current.setting.api_session_id = new_scenario.id
    redirect_to play_path
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    @saved_scenario.update(saved_scenario_parameters)
    reload_current_title(@saved_scenario)

    respond_to do |format|
      format.js
    end
  end

  # Soft-deletes the scenario so that it no longer appears in listings.
  #
  # PUT /saved_scenarios/:id/discard
  def discard
    unless @saved_scenario.discarded?
      @saved_scenario.discarded_at = Time.zone.now
      @saved_scenario.save(touch: false)

      flash.notice = 'Your scenario was put in the trash'
      flash[:undo_params] = [undiscard_saved_scenario_path(@saved_scenario), { method: :put }]
    end

    redirect_back(fallback_location: saved_scenarios_path)
  end

  # Removes the soft-deletes of the scenario.
  #
  # PUT /saved_scenarios/:id/undiscard
  def undiscard
    unless @saved_scenario.kept?
      @saved_scenario.discarded_at = nil
      @saved_scenario.save(touch: false)

      flash.notice = 'Your scenario was restored'
      flash[:undo_params] = [discard_saved_scenario_path(@saved_scenario), { method: :put }]
    end

    redirect_back(fallback_location: discarded_saved_scenarios_path)
  end

  # DELETE /saved_scenarios/:id
  def destroy
    @saved_scenario.destroy
    flash.notice = 'Your scenario was permanently deleted'
    redirect_to discarded_saved_scenarios_path
  end

  private

  def ensure_owner
    return if owned_saved_scenario?

    if request.format.json?
      head(:not_found)
    else
      render_not_found('saved scenario')
    end
  end

  def owned_saved_scenario?(saved_scenario = nil)
    saved_scenario ||= @saved_scenario
    saved_scenario.user_id == current_user&.id
  end

  def scenario_by_current_user?(scenario)
    SavedScenario.where(user: current_user, scenario_id: scenario.id).exists?
  end

  def assign_saved_scenario
    @saved_scenario = SavedScenario.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end

  def assign_scenario
    @scenario = @saved_scenario.scenario(detailed: true)

    unless @scenario&.loadable?
      redirect_to @saved_scenario, notice: 'Sorry, this scenario cannot be loaded'
    end
  rescue ActiveResource::ResourceNotFound
    redirect_to @saved_scenario, notice: 'Scenario not found'
  end

  def saved_scenario_parameters
    params.require(:saved_scenario).permit(:title, :description)
  end

  def reload_current_title(saved_scenario)
    if Current.setting.active_saved_scenario_id == saved_scenario.id
      Current.setting.active_scenario_title = saved_scenario.title
    end
  end
end
