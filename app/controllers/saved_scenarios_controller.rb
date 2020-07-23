# frozen_string_literal: true

# The controller that handles calls to the saved_scenario entity
class SavedScenariosController < ApplicationController
  before_action :ensure_valid_browser
  before_action :assign_saved_scenario, only: %i[show load edit update]
  before_action :assign_scenario, only: :load
  before_action :ensure_owner, only: %i[edit update]
  helper_method :owned_saved_scenario?

  def index
    respond_to do |format|
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

  def show
    if @saved_scenario.days_until_last_update > 180
      warning_type =
        if owned_saved_scenario?
          'warning'
        else
          'preset_warning'
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

    # Setting an active_saved_scenario enables saving a scenario. We only
    # do this for the owner of a scenario.
    Current.setting = if owned_saved_scenario?
      Setting.load_from_scenario(
        @scenario,
        active_saved_scenario: {
          id: @saved_scenario.id,
          title: @saved_scenario.localized_title(I18n.locale)
        }
      )
    else
      Setting.load_from_scenario(@scenario)
    end

    scenario_attrs[:scale] = Current.setting.scaling if Current.setting.scaling
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

  private

  def ensure_owner
    head(:forbidden) unless owned_saved_scenario?
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
