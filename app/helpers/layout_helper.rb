module LayoutHelper
  def search_result_description(result)
    truncate(strip_tags(result.description.content), :length => 160)
  rescue
    nil
  end

  def back_to_model_link
    last_etm_controller_name = Current.setting.last_etm_controller_name
    if last_etm_controller_name.blank?
      link_to t("Home"), root_path
    else
      link_to t("back to model"), :controller => last_etm_controller_name,
                                  :action => session[:last_etm_action_name]
    end
  end

  def current_tutorial_movie
    SidebarItem.find_by_key(params[:id]).andand.send("#{I18n.locale}_vimeo_id")
  end

  def country_option(code, opts = {})
    current = Current.setting.region == code
    selected = current ? "selected='true'" : nil
    %Q{<option value="#{code}" #{selected}>#{I18n.t(code)} #{"(test)" if opts[:test]}</option>}.html_safe
  end

  def percentage_bar(item)
    return if item.percentage_bar_query.blank?
    # need client for showing % bars
    if client ||= Api::Client.new
      client.api_session_id = Current.setting.api_session_id
    end
    val = client.simple_query(item.percentage_bar_query)
    # multiplied by 90 because of interface limits, there should be some space left for the value
    haml_tag :span, :class =>'bar',
                    :style => "width: #{(val * 90).round(2)}%",
                    :alt => I18n.t('sidebar_items.alt')
    haml_tag :span, :class =>'value',
                    :style => "left: #{(val * 90).round(2)}%" do
      haml_concat "#{(val * 100).round}%"
    end
  end

  # Tries mapping a hex string to a human readable colour name
  #
  def color_to_string(hex)
    Colors::COLORS.invert[hex] || hex
  end
end
