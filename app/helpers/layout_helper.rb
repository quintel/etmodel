module LayoutHelper
  def back_to_model_link
    last_etm_page = Current.setting.last_etm_page
    if last_etm_page.blank?
      link_to t("home"), root_path
    else
      link_to t("back_to_model"), last_etm_page
    end
  end

  def current_area_name
    code = Current.setting.area_code
    I18n.t("areas.#{code}", default: code.humanize)
  end

  def current_area_info
    area_name = current_area_name
    capture_haml do
      unless Current.setting.derived_dataset?
        haml_tag 'img',
          src: icon_for_area_code(Current.setting.area_code),
          title: area_name,
          width: 16
      end
      unless Current.setting.area_code.length == 2
        haml_concat area_name
      end
    end
  end

  def country_option(area)
    code = area[:area_code]

    selector = params[:country] || Current.setting.area_code
    selected = selector == code ? "selected='true'" : nil

    label = name_for(code)
    label += " (#{ I18n.t('new') })" if area[:test]

    content_tag :option, label.html_safe,
      value: code,
      selected: selected,
      'data-earliest' => area[:analysis_year] + 1
  end

  def area_links
    options = []

    Api::Area.grouped.map do |group, areas|
      options.push(
        text: I18n.t("country_select.groups.#{ group }"),
        data: areas.sort_by{ |a| name_for(a.area) }.map(&method(:area_choice))
      )
    end

    options
  end

  def area_choice(area)
    if area && (area.useable || admin?)
      { area_code: area.area,
        test: area.test?,
        analysis_year: area.try(:analysis_year) || 2012,
        derived: area.derived? }
    end
  end

  def name_for(area)
    I18n.t("country_select.areas.#{ area }",
      default: ["areas.#{area}".to_sym, area.humanize])
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
    top_area = Api::Area.find_by_country_memoized(code).top_level_area
    "/assets/icons/areas/#{top_area.area}.png"
  end

  def dutch?
    I18n.locale.to_s == 'nl'
  end

  def english?
    I18n.locale.to_s == 'en'
  end

  def scaling_summary
    attribute = Current.setting.scaling[:area_attribute]
    value     = Current.setting.scaling[:value].to_i

    I18n.t(:'local_scenario.summary_html', {
      value:     number_with_delimiter(value),
      attribute: t(:"local_scenario.attributes.#{ attribute }.short"),
      reduction: scaling_reduction
    }).html_safe
  end

  def scaling_reduction
    region  = Current.setting.area
    value   = Current.setting.scaling[:value]
    default =
      Current.setting.scaling[:base_value] ||
      region.public_send(Current.setting.scaling[:area_attribute])

    percent   = (value.to_f / default) * 100
    precision = (percent > 10 ? 0 : (percent < 1 ? 2 : 1))

    number_to_percentage(percent, precision: precision)
  end

  def flags
    @flags ||= Dir.chdir(Rails.root.join('app/assets/images')) do
      Dir.glob("flags-24/*.png")
    end
  end

  def preset_years
    custom_years
      .select { |year| (year % 10).zero? }
      .push([I18n.t('scenario.other').html_safe, 'other'])
  end
end
