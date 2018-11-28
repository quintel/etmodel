module ScenarioHelper
  def current_scenario_scaled?
    Current.setting.scaling.present? || Current.setting.derived_dataset?
  end

  def scaling_sector_checkbox(name, default = true)
    scaled  = Current.setting.scaling.present?
    checked = scaled ? Current.setting.scaling[:"has_#{ name }"] : default

    if scaled
      hidden_field_tag("has_#{ name }", '0') +
      check_box_tag("has_#{ name }", '1', checked, disabled: !checked)
    else
      check_box_tag("has_#{ name }", '1', checked)
    end
  end

  # Determines if the user should be shown the tooltip highlighting the results
  # section.
  def show_results_tip?
    # Logged-in user who has the tip hidden?
    return false if current_user&.hide_results_tip

    setting = session[:hide_results_tip]

    return true unless setting
    return false if setting == :all

    setting != Current.setting.api_session_id
  end
end
