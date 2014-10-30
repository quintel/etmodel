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
end
