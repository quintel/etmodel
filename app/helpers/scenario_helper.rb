module ScenarioHelper
  def current_scenario_scaled?
    Current.setting.scaling.present?
  end
end
