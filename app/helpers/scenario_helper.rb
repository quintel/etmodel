# frozen_string_literal: true

module ScenarioHelper
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

  # Public: Parses a scenario or preset description with Markdown, removing any
  # unsafe links.
  #
  # Returns an HTML safe string.
  def formatted_scenario_description(description, allow_external_links: false)
    # First check if the description has a div matching the current locale,
    # indicating that a localized version is available.
    localized = Loofah.fragment(description).css(".#{I18n.locale}")

    rendered = RDiscount.new(
      localized.inner_html.presence || description || '',
      :no_image, :smart
    ).to_html

    sanitized = Rails::Html::SafeListSanitizer.new.sanitize(rendered)

    # rubocop:disable Rails/OutputSafety
    if allow_external_links
      add_rel_to_external_links(sanitized).html_safe
    else
      strip_external_links(sanitized).html_safe
    end
    # rubocop:enable Rails/OutputSafety
  end

  # Public: Parses the text as HTML, replacing any links to external sites with
  # only their inner text.
  #
  # Returns a string.
  def strip_external_links(text)
    link_stripper = Loofah.fragment(text)

    link_stripper.scrub!(Loofah::Scrubber.new do |node|
      next unless node.name == 'a'

      begin
        uri = URI(node['href'].to_s.strip)
      rescue URI::InvalidURIError
        node.replace(node.inner_text)
        next
      end

      next if uri.relative?

      domain = ActionDispatch::Http::URL.extract_domain(
        uri.host.to_s, ActionDispatch::Http::URL.tld_length
      )

      if !uri.scheme.start_with?('http') && domain != request.domain
        # Disallow any non-HTTP scheme.
        node.replace(node.inner_text)
        next
      end

      node.replace(node.inner_text) unless domain == request.domain
    end)

    link_stripper.inner_html
  end

  # Public: Adds a rel="noopener nofollow" attribute to any external links.
  #
  # Returns a string.
  def add_rel_to_external_links(text)
    link_stripper = Loofah.fragment(text)

    link_stripper.scrub!(Loofah::Scrubber.new do |node|
      next unless node.name == 'a'

      begin
        uri = URI(node['href'].to_s.strip)
        next if uri.relative?
      rescue URI::InvalidURIError
        # Remove the link with the text.
        node.replace(node.inner_text)
        next
      end

      domain = ActionDispatch::Http::URL.extract_domain(
        uri.host.to_s, ActionDispatch::Http::URL.tld_length
      )

      if !uri.scheme.start_with?('http') && domain != request.domain
        # Disallow any non-HTTP scheme.
        node.replace(node.inner_text)
        next
      end

      node[:rel] = 'noopener nofollow' unless domain == request.domain
    end)

    link_stripper.inner_html
  end

  # Public: Given a string, converts CO2 to have a subscript 2.
  #
  # Returns an HTML-safe string.
  def format_subscripts(string)
    # rubocop:disable Rails/OutputSafety
    h(string).gsub(/\bCO2\b/, 'CO<sub>2</sub>').html_safe if string.present?
    # rubocop:enable Rails/OutputSafety
  end

  # Public: Returns true if there is a special warning for the scenario
  #
  # Current use: dataset 2023 update for Dutch regions. Show banner
  # when scenario on latest with elegible dataset
  def warning_for(scenario)
    %w[GM RES PV].any? { |code| scenario.area_code.start_with?(code) }
  end

  # Public: Renders the HTML for an electricity interconnector price curve
  # upload form.
  #
  # num - The number of the interconnector (1-12).
  def interconnector_price_curve_upload(num)
    render partial: 'scenarios/slides/interconnector_curves_upload', locals: { num: }
  end

  # Public: Creates a link to view the source data behind the current area in the ETM Dataset
  # Manager.
  def link_to_datamanager_for_current_area
    "https://data.energytransitionmodel.com/datasets/#{Current.setting.area_code.split('_')[0]}"
  end

  # Public: Checks if a link to the Dataset Manager should be shown for the current
  # area. Currently only 'NL' will not be linked.
  def show_link_to_datamanager?
    %w[eu nl nl2019 nl2023].exclude?(Current.setting.area_code)
  end

  # Public: Creates the warning message shown when the scenario was created with a previous version
  # of the model.
  def previous_version_scenario_warning(scenario, current_release_date)
    return if scenario.updated_at >= current_release_date

    t(
      'scenario.warning.message',
      last_updated: l(scenario.updated_at.to_date, format: :long),
      release_date: l(current_release_date.to_date, format: :long)
    )
  end

  # Classes for the scenario row on the scenario listing.
  def classes_for_scenario_row(saved_scenario)
    [
      saved_scenario.discarded? ? 'discarded' : nil,
      saved_scenario.loadable? ? '' : 'unavailable'
    ].compact.join(' ')
  end

  # Shows the number of scenarios in a tab. When the number is zero nothing is shown.
  def tab_count(count, options = {})
    return if count.zero?

    tag.span(number_with_delimiter(count), class: "count #{options[:class]}".strip)
  end
end
