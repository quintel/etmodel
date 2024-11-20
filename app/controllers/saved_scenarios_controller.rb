# frozen_string_literal: true

# The controller that handles calls to the saved_scenario entity
class SavedScenariosController < ApplicationController
  load_resource only: %i[load discard undiscard publish unpublish restore confirm_restore]
  load_and_authorize_resource only: %i[show new create edit update destroy]

  before_action :require_user, only: :discarded

  before_action only: %i[load] do
    authorize!(:read, @saved_scenario)
  end

  before_action only: %i[publish unpublish] do
    authorize!(:update, @saved_scenario)
  end

  before_action only: %i[discard undiscard restore confirm_restore] do
    authorize!(:destroy, @saved_scenario)
  end

  before_action :restrict_to_admin, only: :all
  before_action :assign_scenario, only: :load
  helper_method :editable_saved_scenario?

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
    @discarded_scenarios = Kaminari.paginate_array(
        (
          current_user.saved_scenarios.discarded.includes(:featured_scenario, :users) +
          current_user.multi_year_charts.discarded.includes(:user)
        )
        .sort_by(&:updated_at)
      )
      .page(params[:page])
      .per(10)

    respond_to do |format|
      format.html
    end
  end

  def all
    @saved_scenarios = SavedScenario.all
      .includes(:featured_scenario, :users)
      .order('updated_at DESC')
      .page(params[:page])
      .per(10)

    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html { @saved_scenario.loadable? ? render : redirect_to(root_path) }
      format.js { @saved_scenario.loadable? ? render : redirect_to(root_path) }
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
    ss_params = params.require(:saved_scenario).permit(:description, :title, :scenario_id, :area_code, :end_year)
      .merge(area_code: Current.setting.area_code, end_year: Current.setting.end_year)

    result = CreateSavedScenario.call(idp_client, ss_params[:scenario_id], current_user, ss_params)

    if result.failure?
      render :new, status: :unprocessable_entity and return
    end

    saved_scenario = result
    if Current.setting.api_session_id == ss_params[:scenario_id].to_i
      Current.setting.active_scenario_title = saved_scenario.value['title']
      Current.setting.active_scenario_title = saved_scenario.value['scenario_id']
    end

    redirect_to(Current.setting.last_etm_page.presence || play_path)
  end

  def load
    scenario_attrs = { scenario_id: params[:engine_id] }

    # Setting an active_saved_scenario enables saving a scenario. We only
    # do this for the owner of a scenario.
    Current.setting =
      Setting.load_from_scenario(
        @scenario,
        active_saved_scenario: {
          id: editable_saved_scenario?(for_admin: false) ? params[:id] : nil,
          title: params[:name]
        }
      )

    new_scenario = CreateAPIScenario.call(engine_client, scenario_attrs).or do
      flash[:alert] = t('scenario.cannot_load')
      return redirect_to(saved_scenario_path(params[:id]))
    end

    Current.setting.api_session_id = new_scenario.id
    redirect_to play_path
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    @saved_scenario.update(saved_scenario_params)
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

      flash.notice = t('scenario.trash.discarded_flash')
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

      flash.notice = t('scenario.trash.undiscarded_flash')
      flash[:undo_params] = [discard_saved_scenario_path(@saved_scenario), { method: :put }]
    end

    redirect_back(fallback_location: discarded_saved_scenarios_path)
  end

  # Makes a scenario public.
  def publish
    @saved_scenario.update(private: false)

    UpdateAPIScenarioPrivacy.call_with_ids(
      engine_client,
      [@saved_scenario.scenario_id, *@saved_scenario.scenario_id_history],
      private: false
    )

    redirect_to saved_scenario_path(@saved_scenario)
  end

  # Makes a scenario private.
  def unpublish
    @saved_scenario.update(private: true)

    UpdateAPIScenarioPrivacy.call_with_ids(
      engine_client,
      [@saved_scenario.scenario_id, *@saved_scenario.scenario_id_history],
      private: true
    )

    redirect_to saved_scenario_path(@saved_scenario)
  end

  def confirm_restore
    @scenario_id = restore_params[:scenario_id].to_i

    render 'confirm_restore', layout: false
  end

  # Restores a saved scenario to a previous version
  def restore
    result = RestoreSavedScenario.call(
      engine_client,
      @saved_scenario,
      restore_params[:scenario_id].to_i
    )

    flash.notice =
      if result.successful?
        t('flash.scenario_restored')
      else
        t('flash.scenario_cannot_be_restored')
      end

    respond_to do |format|
      format.js
    end
  end

  # DELETE /saved_scenarios/:id
  def destroy
    @saved_scenario.destroy
    flash.notice = t('scenario.trash.deleted_flash')
    redirect_to discarded_saved_scenarios_path
  end

  private

  # This determines whether the SavedScenario is editable by the current_user
  def editable_saved_scenario?(saved_scenario = nil, for_admin: true)
    saved_scenario ||= @saved_scenario

    saved_scenario.collaborator?(current_user) ||
      saved_scenario.owner?(current_user) ||
      (current_user&.admin? && for_admin)
  end

  def assign_saved_scenario
    @saved_scenario = SavedScenario.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end

  def assign_scenario
    @scenario ||= FetchAPIScenario.call(engine_client, params[:engine_id]).or(nil)

    unless @scenario&.loadable?
      redirect_to @saved_scenario, notice: 'Sorry, this scenario cannot be loaded'
    end
  rescue ActiveResource::ResourceNotFound
    redirect_to @saved_scenario, notice: 'Scenario not found'
  end

  def saved_scenario_params
    params.require(:saved_scenario).permit(:title, :description)
  end

  def restore_params
    params.require(:saved_scenario).permit(:scenario_id)
  end

  def reload_current_title(saved_scenario)
    if Current.setting.active_saved_scenario_id == saved_scenario.id
      Current.setting.active_scenario_title = saved_scenario.title
    end
  end
end
