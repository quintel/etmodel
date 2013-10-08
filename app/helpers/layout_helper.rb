module LayoutHelper
  def search_result_description(result)
    truncate(strip_tags(result.description.content), :length => 160)
  rescue
    nil
  end

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
    label = I18n.t(code)
    label += ' (test)' if opts[:test]
    content_tag :option, label.html_safe, :value => code, :selected => selected
  end

  def area_links
    links = []
    add_area_choice links, "nl"

    # Provinces of the Netherlands

    links_nl = []

    add_area_choice links_nl, "nl-drenthe"
    add_area_choice links_nl, "nl-flevoland"
    add_area_choice links_nl, "nl-friesland"
    add_area_choice links_nl, "nl-gelderland"
    add_area_choice links_nl, "nl-limburg"
    add_area_choice links_nl, "nl-noord-brabant"
    add_area_choice links_nl, "nl-noord-holland"
    add_area_choice links_nl, "nl-overijssel"
    add_area_choice links_nl, "nl-utrecht"
    add_area_choice links_nl, "nl-zeeland"
    add_area_choice links_nl, "nl-zuid-holland"
    add_area_choice links_nl, "nl-noord"                       if @show_all

    links.push text: "Provinces of the Netherlands" ,          data: links_nl

    # Municipalities of the Netherlands

    links_municipalities = []

    add_area_choice links_municipalities, "ams",               true
    add_area_choice links_municipalities, "grs",               true

    links.push text: "Municipalities of the Netherlands" ,     data: links_municipalities

    # Germany

    add_area_choice links, "de",                               true

    if @show_german_provinces
      links_de = []
      add_area_choice links_de, "br",                          true

      links.push text: "Provinces of Germany",                 data: links_de
    end

    # Other countries

    add_area_choice links, "uk",                               true
    add_area_choice links, "ro",                               true
    add_area_choice links, "pl",                               true
    add_area_choice links, "tr",                               true
    add_area_choice links, "za",                               true if session[:show_all_countries]
    add_area_choice links, "be-vlg",                           true if session[:show_all_countries] || session[:show_flanders]
    return links
  end

  def add_area_choice(collection, area_code, test = false)
    if area = Api::Area.find_by_country_memoized(area_code)
      if area.useable? || admin?
        collection.push(area_code: area_code, test: test)
      end
    end
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
end
