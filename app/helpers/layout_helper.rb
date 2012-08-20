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

  def current_tutorial_movie
    SidebarItem.find_by_key(params[:sidebar]).andand.send("#{I18n.locale}_vimeo_id")
  end

  def current_description

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
    links.push area_code: "nl"
    links_nl = []
      links_nl.push area_code: "nl-drenthe"
      links_nl.push area_code: "nl-flevoland"
      links_nl.push area_code: "nl-friesland"
      links_nl.push area_code: "nl-gelderland"
      links_nl.push area_code: "nl-limburg"
      links_nl.push area_code: "nl-noord-brabant"
      links_nl.push area_code: "nl-noord-holland"
      links_nl.push area_code: "nl-overijssel"
      links_nl.push area_code: "nl-utrecht"
      links_nl.push area_code: "nl-zeeland"
      links_nl.push area_code: "nl-zuid-holland"
      links_nl.push area_code: "nl-noord"                       if @show_all
    links.push text: "Provinces of the Netherlands" ,           data: links_nl
    links_municipalities = []
      links_municipalities.push area_code: "nl-zeeland" ,       test: true
      links_municipalities.push area_code: "nl-zuid-holland" ,  test: true
    links.push text: "Municipalities of the Netherlands" ,      data: links_municipalities
    links.push area_code: "de"
   if @show_german_provinces
     links_de = []
       links_de.push area_code: "br" ,                          test: true
     links.push text: "Provinces of Germany" ,                  data: links_de
   end
   links.push area_code: "uk" ,                                 test: true
   links.push area_code: "ro" ,                                 test: true
   links.push area_code: "pl" ,                                 test: true
   links.push area_code: "tr" ,                                 test: true
   links.push area_code: "za" ,                                 test: true if session[:show_all_countries]
   links.push area_code: "be-vlg" ,                             test: true if session[:show_all_countries] || session[:show_flanders]
   return links
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
