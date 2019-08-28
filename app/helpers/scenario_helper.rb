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

      uri = URI(node['href'].to_s)

      unless uri.relative? || uri.host == request.host
        node.replace(node.inner_text)
      end
    end)

    link_stripper.inner_html
  end
end
