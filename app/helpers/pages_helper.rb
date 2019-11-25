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

  # Public: Returns an image tag to the flag representing the given area.
  def area_flag_icon(area_or_code)
    unless area_or_code.is_a?(Api::Area)
      area_or_code = Api::Area.find_by_country_memoized(area_or_code)
    end

    image_tag(
      "flags-24/#{area_css_class(area_or_code)}.png",
      class: 'area-flag', alt: ''
    )
  end

  # Public: Returns the options for the co2 factsheet.
  def co2_factsheet_options
    {
      area: @area.area,
      host: APP_CONFIG[:api_url],
      max_year: Setting::MAX_YEAR,
      min_year: Setting::MIN_YEAR,
      default_year: Setting::DEFAULT_YEAR,
      scenario_id: params[:scenario],
      time: @time,
      non_energy: params[:non_energy]
    }
  end
end
