module LayoutHelper
  def back_to_model_link
    last_etm_page = Current.setting.last_etm_page
    if last_etm_page.blank?
      link_to t("home"), root_path
    else
      link_to t("back_to_model"), last_etm_page
    end
  end

  def country_option(code, opts = {})
    current = Current.setting.area_code == code
    selected = current ? "selected='true'" : nil

    label = I18n.t("country_select.#{ code }", default: I18n.t(code))
    label += " (#{ I18n.t('new') })" if opts[:test]

    content_tag :option, label.html_safe, :value => code, :selected => selected,
      'data-earliest' => opts[:earliest] || 2013
  end

  def area_links
    [ area_choice('fr'),
      area_choice('de'),
      area_choice('nl'),
      area_choice('pl'),
      area_choice('es'),
      area_choice('uk'),
      :separator,
      area_choice('eu')
    ].compact
  end

  def area_choice(area_code)
    area = Api::Area.find_by_country_memoized(area_code)

    if area && (area.useable || admin?)
      { area_code: area_code }
    end
  end

  # Creates the language selection drop-down.
  def language_select
    languages = [['English',    :en],
                 ['Nederlands', :nl]]

    select_tag "locale", options_for_select(languages, I18n.locale)
  end

  # Tries mapping a hex string to a human readable colour name
  #
  def color_to_string(hex)
    Colors::COLORS.invert[hex] || hex
  end

  # Returns a URL to the image for the current area code.
  def icon_for_area_code(code)
    "/assets/icons/areas/#{ code.split('-').first }.png"
  end

  def dutch?
    I18n.locale.to_s == 'nl'
  end

  def english?
    I18n.locale.to_s == 'en'
  end

  def scaling_reduction
    region    = Current.setting.area
    value     = Current.setting.scaling[:value]
    default   = region.public_send(Current.setting.scaling[:area_attribute])

    percent   = (value.to_f / default) * 100
    precision = (percent > 10 ? 0 : (percent < 1 ? 2 : 1))

    number_to_percentage(percent, precision: precision)
  end

  # Public: Creates a drop-down of preset and user-saved scenarios.
  def presets_select
    grouped = Api::Scenario.in_groups(Api::Scenario.all(:from => :templates))

    # Global presets.
    grouped_options = grouped.map do |group|
      options   = group[:scenarios].map { |s| [s.title, s.id] }
      group_key = group[:name].to_s.downcase.gsub(/\s+/, '_').presence

      [t("scenario.#{ group_key }", default: group[:name]), options]
    end

    # Logged-in user's saved scenarios.
    if current_user
      available_scenarios = current_user.saved_scenarios.select(&:scenario)

      if available_scenarios.any?
        user_scenarios = available_scenarios.reverse.map do |ss|
          [ss.scenario.title, ss.scenario.id]
        end

        grouped_options.unshift([t('scenario.saved'), user_scenarios])
      end
    end

    select_tag 'id', grouped_options_for_select(grouped_options), id: :preset_id
  end
end
