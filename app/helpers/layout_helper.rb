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

  # Tries mapping a hex string to a human readable colour name
  #
  def color_to_string(hex)
    Colors::COLORS.invert[hex] || hex
  end
end
