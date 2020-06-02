# frozen_string_literal: true

# The controller that handles calls to the saved_scenario entity
class SavedScenariosController < ApplicationController
  before_action :ensure_valid_browser
  before_action :assign_scenario, only: %i[show load]

  def index
    respond_to do |format|
      format.json do
        if current_user
          render json:
            SavedScenarioPresenter.new(
              current_user.saved_scenarios.order('created_at DESC')
            )
        else
          render json: []
        end
      end
    end
  end

  def show
    if @scenario.created_at && @scenario.days_old > 180
      warning_type =
        if scenario_by_current_user?(@scenario)
          'preset_warning'
        else
          'warning'
        end
      @warning = t("scenario.#{warning_type}")
    end

    respond_to do |format|
      format.html
      format.csv
    end
  end

  def load
    scenario_attrs = { scenario_id: @saved_scenario.scenario_id }

    # Setting an active_saved_scenario_id enables saving a scenario. We only
    # do this for the owner of a scenario.
    if @saved_scenario.user_id == current_user&.id
      Current.setting = Setting
        .load_from_scenario(@scenario,
                            active_saved_scenario_id: @saved_scenario.id)
    else
      Current.setting = Setting.load_from_scenario @scenario
    end

    scenario_attrs[:scale] = Current.setting.scaling if Current.setting.scaling
    new_scenario = Api::Scenario.create(scenario: { scenario: scenario_attrs })
    Current.setting.api_session_id = new_scenario.id
    redirect_to play_path
  end

  private

  def scenario_by_current_user?(scenario)
    SavedScenario.where(user: current_user, scenario_id: scenario.id).exists?
  end

  def assign_scenario
    @saved_scenario = SavedScenario.find(params[:id])
    @scenario = @saved_scenario.scenario(detailed: true)

    unless @scenario&.loadable?
      redirect_to root_path, notice: 'Sorry, this scenario cannot be loaded'
    end
  rescue ActiveResource::ResourceNotFound
    redirect_to root_path, notice: 'Scenario not found'
  end
end
