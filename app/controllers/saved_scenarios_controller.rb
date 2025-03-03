# frozen_string_literal: true

# The controller that handles calls to the saved_scenario entity
class SavedScenariosController < ApplicationController
  before_action :require_user, only: %i[create new]
  before_action :check_authentication, only: %i[load]

  # Shows a form for creating a new saved scenario.
  #
  # GET /scenarios/:scenario_id/save
  def new
    @saved_scenario = SavedScenario.new(
      scenario_id: Current.setting.api_session_id,
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

  # Redirect to MyETM
  def show
    redirect_to "#{Settings.identity.issuer}/saved_scenarios/#{params[:id]}", allow_other_host: true
  end

  # Saves a scenario by creating a SavedScenario.
  #
  # This implies two DB records: a SavedSenario in my ETM and a Scenario in ETEngine. MyETM
  # stores the user_id,  scenario_id, and some other useful scenario metadata..
  #
  # POST /saved_scenarios
  def create
    if create_saved_scenario.failure? || new_api_scenario.failure?
      @saved_scenario = SavedScenario.new(
        scenario_id: saved_scenario_params[:scenario_id].to_i,
        title: saved_scenario_params[:title].presence || '',
        area_code: Current.setting.area_code,
        end_year: Current.setting.end_year
      )

      # Add error from failure
      flash[:alert] = t('scenario.cannot_save')

      render :new and return
    end

    Current.setting.update_scenario_session(
      new_api_scenario.value,
      saved_scenario_id: create_saved_scenario.value['id'].to_i,
      title: saved_scenario_params[:title]
    )

    redirect_to(Current.setting.last_etm_page.presence || play_path)
  end

  # Loads a saved scenario and sets the scenario.
  #
  # GET /saved_scenarios/:id
  def load
    return redirect_to(root_path) unless saved_scenario

    # If a user was already working in the scenario, a new engine scenario
    # should not be made in order for them to continue to work
    if active_scenario?
      update_active_scenario_title
      return redirect_to play_path
    end

    if current_user || !saved_scenario.private
      if api_scenario_for_load.failure?
        flash[:alert] = t('scenario.cannot_load')
        return redirect_to(root_path)
      end

      create_scenario_and_load_setting(
        saveable: current_user && saved_scenario.collaborator?(current_user)
      )
      return redirect_to play_path
    end

    flash[:alert] = t('scenario.unauthorized')
    redirect_to root_path
  end

  def update
    session_id = Current.setting.api_session_id

    result = UpdateSavedScenario.call(
      my_etm_client,
      update_params[:id],
      update_params[:scenario_id]
    )

    if result.failure?
      return respond_to do |format|
        format.json { render json: { error: 'Failed to update' }, status: :unprocessable_entity }
      end
    end

    new_scenario = CreateAPIScenario.call(
      engine_client, { scenario_id: update_params[:scenario_id] }
    )

    if new_scenario.successful?
      Current.setting.preset_scenario_id = session_id
      Current.setting.api_session_id = new_scenario.value.id
      session_id = new_scenario.value.id
    end

    respond_to do |format|
      format.json { render json: { api_session_id: session_id } }
    end
  end

  private

  # If a param is passed from myETM that the user was logged in in there,
  # check if etmodel has a session set up yet and prompt the user otherwise
  def check_authentication
    authenticate_user!(show_as: :sign_in) if !signed_in? && params[:current_user] == 'true'
  end

  def saved_scenario
    @saved_scenario ||= FetchSavedScenario.call(my_etm_client, params[:id]).or do |_error|
      flash[:alert] = t('scenario.cannot_load')
      nil
    end
  end

  # Check if the scenario id also matches the preset. That way we are sure
  # the historical versions match up.
  def active_scenario?
    Current.setting.active_saved_scenario_id == params[:id].to_i &&
      Current.setting.preset_scenario_id == saved_scenario.scenario_id
  end

  def update_active_scenario_title
    Current.setting.active_scenario_title = saved_scenario.title
  end

  # Creates a copy of the underlying scenario id and
  def create_scenario_and_load_setting(saveable: false)
    Current.setting = Setting.load_with_preset(
      api_scenario_for_load.value,
      saved_scenario.scenario_id,
      active_saved_scenario: {
        id: saveable ? params[:id].to_i : nil,
        title: saved_scenario.title
      }
    )
  end

  def api_scenario_for_load
    @api_scenario_for_load ||=
      CreateAPIScenario.call(
        engine_client,
        { scenario_id: saved_scenario.scenario_id }
      )
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

  def saved_scenario_params
    create_params.merge(
      area_code: Current.setting.area_code,
      end_year: Current.setting.end_year
    )
  end

  def create_saved_scenario
    @create_saved_scenario ||= CreateSavedScenario.call(
      my_etm_client,
      saved_scenario_params[:scenario_id],
      saved_scenario_params
    )
  end

  def new_api_scenario
    @new_api_scenario ||= CreateAPIScenario.call(
      engine_client,
      { scenario_id: saved_scenario_params[:scenario_id] }
    )
  end
end
