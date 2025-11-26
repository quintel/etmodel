module PagesHelper
  # Public: Determines if the "Releases" banner should be shown
  # in staging and production environments.
  def show_releases_banner?
    if Settings.releases_cutoff
      Date.today < Settings.releases_cutoff
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
    return '' if area.area == 'UKNI01_northern_ireland'
    return area.area.downcase if area.country_area.area == 'eu'

    area ? area.country_area.area : ''
  end

  # Public: Returns an image tag to the flag representing the given area.
  def area_flag_icon(area_or_code)
    unless area_or_code.is_a?(Engine::Area)
      area_or_code = Engine::Area.find_by_country_memoized(area_or_code)
    end

    path = "flags-24/#{area_css_class(area_or_code).to_s.downcase}.png"
    image_tag(path, class: 'area-flag', alt: '') if asset_exists?(path)
  end

  def placeholder_area_flag
    tag.span(class: 'area-flag placeholder-area-flag')
  end

  # Public: Returns the options for the co2 factsheet.
  def co2_factsheet_options
    {
      area: @area.area,
      host: Settings.ete_url,
      max_year: Setting::MAX_YEAR,
      min_year: Setting::MIN_YEAR,
      default_year: Setting::DEFAULT_YEAR,
      scenario_id: params[:scenario],
      time: @time,
      non_energy: params[:non_energy],
      access_token: signed_in? ? identity_access_token.token : nil
    }
  end

  # Public: Path to redirect the user when using an unsupported browser, but they choose to continue
  # anyway.
  def allow_unsupported_browser_path
    url = URI(params[:location] || '/')

    if url.query
      "#{url.path}?#{url.query}&allow_unsupported_browser=true"
    else
      "#{url.path}?allow_unsupported_browser=true"
    end
  end

  def learn_link(text, url)
    external = if url.start_with?('http')
      # Tailwind external-link
      tag.svg(xmlns: 'http://www.w3.org/2000/svg', viewBox: '0 0 20 20', fill: 'currentColor', class: 'external') do
        tag.path('d' => 'M11 3a1 1 0 100 2h2.586l-6.293 6.293a1 1 0 101.414 1.414L15 6.414V9a1 1 0 102 0V4a1 1 0 00-1-1h-5z') +
          tag.path('d' => 'M5 5a2 2 0 00-2 2v8a2 2 0 002 2h8a2 2 0 002-2v-3a1 1 0 10-2 0v3H5V7h3a1 1 0 000-2H5z')
      end
    end

    external_props = if url.start_with?('http')
      { target: '_blank', rel: 'noopener noreferrer' }
    else
      {}
    end

    link_to(url, class: 'learn-link', **external_props) do
      # Tailwind minus-sm
      tag.svg(xmlns: 'http://www.w3.org/2000/svg', viewBox: '0 0 20 20', fill: 'currentColor', class: 'dash') do
        tag.path(
          'fill-rule' => 'evenodd',
          'd' => 'M5 10a1 1 0 011-1h8a1 1 0 110 2H6a1 1 0 01-1-1z',
          'clip-rule' => 'evenodd'
        )
      end +
        tag.span(text) + external
    end
  end
end
