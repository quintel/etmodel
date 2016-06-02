module ScenarioHelper
  def current_scenario_scaled?
    Current.setting.scaling.present?
  end

  def scaling_sector_checkbox(name, default = true)
    scaled  = Current.setting.scaling.present?
    checked = scaled ? Current.setting.scaling[:"has_#{ name }"] : true

    check_box_tag("has_#{ name }", '1', checked, disabled: false)
  end
end
