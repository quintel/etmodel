module ScenarioHelper
  def current_scenario_scaled?
    Current.setting.scaling.present?
  end

  def scaling_sector_checkbox(name, default = true)
    scaled  = Current.setting.scaling.present?
    checked = scaled ? Current.setting.scaling[:"has_#{ name }"] : default

    if scaled && checked
      check_box_tag("has_#{ name }", '1', checked, disabled: true) +
      hidden_field_tag("has_#{ name }", '1')
    else
      check_box_tag("has_#{ name }", '1', checked, disabled: scaled)
    end
  end
end
