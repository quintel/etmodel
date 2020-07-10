# frozen_string_literal: true

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

  # Public: Parses a scenario or preset description with Markdown, removing any
  # unsafe links.
  #
  # Returns an HTML safe string.
  def formatted_scenario_description(description)
    # First check if the description has a div matching the current locale,
    # indicating that a localized version is available.
    localized = Loofah.fragment(description).css(".#{I18n.locale}")

    rendered = RDiscount.new(
      localized.inner_html.presence || description,
      :no_image, :smart
    ).to_html

    Rails::Html::SafeListSanitizer.new.sanitize(
      strip_external_links(rendered)
    ).html_safe
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

      node.replace(node.inner_text) unless domain == request.domain
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

  # Public: Renders the HTML needed to show a price curve upload form.
  #
  # curve_name - The name/type of the curve.
  # input_name - An option input key which will be set to disabled if the
  #              scenario has a curve attached.
  def price_curve_upload(curve_name, input_key)
    render partial: 'scenarios/slides/price_curve_upload', locals: {
      associated_input: input_key,
      curve_name: curve_name
    }
  end

  # Public: Renders the HTML for an electricity interconnector price curve
  # upload form.
  #
  # num - The number of the interconnector (1-6).
  def interconnector_price_curve_upload(num)
    price_curve_upload(
      "interconnector_#{num}_price",
      "electricity_interconnector_#{num}_marginal_costs"
    )
  end
end
