class SavedScenariosController < ApplicationController
  before_action :ensure_valid_browser
  before_action :assign_scenario, only: %i[show load]

  def show
    if @scenario.created_at && @scenario.days_old > 180
      if SavedScenario.where('user_id = ? AND scenario_id = ?',
                             current_user,
                             @scenario.id).empty?
        @warning = t('scenario.preset_warning')
      else
        @warning = t('scenario.warning')
      end
    end
  end

  def load
    scenario_attrs = { scenario_id: @saved_scenario.scenario_id }

    # Setting an active_saved_scenario_id enables saving a scenario. We only
    # do this for the owner of a scenario.
    if @saved_scenario.user_id == current_user&.id
      Current.setting = Setting.load_from_scenario(@scenario,
                          active_saved_scenario_id: @saved_scenario.id)
    else
      Current.setting = Setting.load_from_scenario @scenario
    end

    if Current.setting.scaling
      scenario_attrs.merge!(scale: Current.setting.scaling)
    end
    new_scenario = Api::Scenario.create(scenario: { scenario: scenario_attrs })
    Current.setting.api_session_id = new_scenario.id
    redirect_to play_path
  end

  private

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
