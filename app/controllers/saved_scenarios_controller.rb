# frozen_string_literal: true

# The controller that handles calls to the saved_scenario entity
class SavedScenariosController < ApplicationController
  before_action :require_user, only: %i[create new]

  def show
    respond_to do |format|
      format.csv { @saved_scenario.loadable? ? render : render_not_found }
      format.html { redirect_to "#{Settings.idp_url}/saved_scenarios/#{params[:id]}"}
    end
  end

  # Shows a form for creating a new saved scenario.
  #
  # GET /scenarios/:scenario_id/save
  def new
    @saved_scenario = SavedScenario.new(
      scenario_id: params.require(:scenario_id).to_i,
      title: params[:title].presence || "",
      area_code: Current.setting.area_code,
      end_year: Current.setting.end_year
    )

    if params[:inline]
      render 'new', layout: false
    else
      render 'new'
    end
  end

  # Saves a scenario by creating a SavedScenario.
  #
  # This implies two DB records: a SavedSenario in my ETM and a Scenario in ETEngine. MyETM
  # stores the user_id,  scenario_id, and some other useful scenario metadata..
  #
  # POST /saved_scenarios
  def create
    if create_saved_scenario.failure?
      render :new, status: :unprocessable_entity and return
    end

    new_scenario = CreateAPIScenario.call(engine_client, { scenario_id: saved_scenario_params[:scenario_id] })

    # TODO: refactor as method on current setting
    Current.setting.api_session_id = new_scenario.value.id
    Current.setting.active_scenario_title = saved_scenario_params[:title]
    Current.setting.active_saved_scenario_id = create_saved_scenario.value['id']

    redirect_to(Current.setting.last_etm_page.presence || play_path)
  end

  def load
    # NOTE: it is more neat if this action asks myetm for the info
    # instead of just taking it from the params. It's also more
    # secure (FetchSavedScenario)

    # Make sure that if the requested saved scenario was already active
    # we do not create a new scenario. Only check if the title has been updated.
    if Current.setting.active_saved_scenario_id == load_params[:id].to_i
      Current.setting.active_scenario_title = load_params[:name]
    else
      # Setting an active_saved_scenario enables saving a scenario. We only
      # do this for the owner of a scenario.
      Current.setting =
        Setting.load_from_scenario(
          find_scenario,
          active_saved_scenario: {
            id: load_params[:id].to_i,
            title: load_params[:name]
          }
        )

      scenario_attrs = { scenario_id: load_params[:scenario_id] }
      new_scenario = CreateAPIScenario.call(engine_client, scenario_attrs).or do
        flash[:alert] = t('scenario.cannot_load')
        return redirect_to(saved_scenario_path(load_params[:id]))
      end

      Current.setting.api_session_id = new_scenario.id
    end

    redirect_to play_path
  end

  def update
    session_id = Current.setting.api_session_id

    result = UpdateSavedScenario.call(
      idp_client,
      update_params[:id],
      update_params[:scenario_id]
    )

    if result.failure?
      # fails and returns
    end

    new_scenario = CreateAPIScenario.call(
      engine_client, { scenario_id: update_params[:scenario_id] }
    )

    if new_scenario.successful?
      Current.setting.api_session_id = new_scenario.value.id
      session_id = new_scenario.value.id
    end

    respond_to do |format|
      format.json { render json: { api_session_id: session_id } }
    end
  end

  private

  # Finds the scenario from id
  def find_scenario
    scenario = FetchAPIScenario.call(engine_client, params.require(:scenario_id).to_i).or do
      redirect_to root_path, notice: 'Scenario not found'
      return
    end

    redirect_to root_path, notice: 'Sorry, this scenario cannot be loaded' unless scenario.loadable?

    scenario
  end

  def update_params
    params.permit(:id, :scenario_id)
  end

  def create_params
    params.require(:saved_scenario).permit(
      :title,
      :scenario_id,
      :area_code,
      :end_year
    )
  end

  def load_params
    params.permit(:id, :scenario_id, :title)
  end

  def saved_scenario_params
    create_params.merge(
      area_code: Current.setting.area_code,
      end_year: Current.setting.end_year
    )
  end

  def create_saved_scenario
    @create_saved_scenario ||= CreateSavedScenario.call(
      idp_client,
      saved_scenario_params[:scenario_id],
      saved_scenario_params
    )
  end
end
