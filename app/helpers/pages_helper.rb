module PagesHelper
  # Public: Determines if the "What's new in the ETM?" banner should be shown
  # in staging and production environments.
  def show_whats_new_banner?
    if APP_CONFIG[:whats_new_cutoff]
      Date.today < APP_CONFIG[:whats_new_cutoff]
    else
      Rails.env.development?
    end
  end

  # Public: Returns if the active scenario is using a non-standard (non-decade)
  # year.
  #
  # Returns true or false.
  def other_year_selected?
    !preset_years.include?(Current.setting.end_year)
  end

  def custom_years
    (Setting::MIN_YEAR..Setting::MAX_YEAR)
  end

  # Public: The CSS class which may be used to represent the area.
  #
  # Returns true or false.
  def area_css_class(area)
    area ? area.top_level_area.area : ''
  end
end
