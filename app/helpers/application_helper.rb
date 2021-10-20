module ApplicationHelper
  def has_active_scenario?
    Current.setting.active_scenario? || @active_scenario
  end

  def flash_message(type = nil)
    if type.nil?
      flash_message(:notice) if flash[:notice]
      flash_message(:error) if flash[:error]
    else
      haml_tag 'div#flash', class: type.to_s do
        haml_tag :p do
          haml_concat flash[type]
          haml_tag :small, link_to('close', '#', onclick: "$('#flash').hide();")
        end
      end
    end
  end

  def t_db(key)
    begin
      Text.find_by_key(key).content.html_safe
    rescue
      "translation missing, #{I18n.locale.to_s.split('-').first} #{key}"
    end
  end

  # Returns the dashboard_items which belong to the given `group`.
  #
  # This method will actually fetch and cache all dashboard_items, assuming that
  # you will eventually want the dashboard_items for all the other groups anyway.
  #
  # Used in views/dashboard_items/_changer.html
  #
  # @param  [String] group The name of the group.
  # @return [Array(DashboardItem)]
  #
  def dashboard_items_for_group(group)
    @_grouped_dashboard_items ||= DashboardItem.enabled.group_by(&:group)
    @_grouped_dashboard_items[group]
  end

  # Used to show a notice in the admin section
  #
  def live_server?
    Settings.live_server
  end

  def live_server_type
    if Settings.live_server.is_a?(String)
      Settings.live_server
    else
      'production'
    end
  end

  def to_yml_syntax(title)
    title.parameterize.underscore.to_sym
  end

  def is_beta?
    request.host_with_port =~ /beta/
    true
  end

  def domain
    request.host_with_port
      .gsub(/\Abeta\./,'')
      .gsub(/\Apro\./,'')
      .gsub(/\Abeta-pro\./, '')
  end

  # DEBT: These information links are no longer rendered anywhere. Most of them
  #       (privacy statement, etc) are currently on etcentral. These links below
  #       should be removed together with their views and controllers
  def information_links
    links = []
    links.push text: t("header.partners") ,           url: "http://#{ "beta." if is_beta? }#{ domain }/partners?locale=#{ I18n.locale }", target: "_new"
    links.push text: t("header.about_qi") ,           url: "http://quintel.com", target: "_new"
    links.push text: t("header.education") ,          url: "http://onderwijs.quintel.nl/", target: "_new"
    links.push text: t("header.press_releases") ,     url: "http://#{ "beta." if is_beta? }#{ domain }/press_releases?locale=#{ I18n.locale }", target: "_new"
    links.push text: t("header.quality_control") ,    url: "http://#{ "beta." if is_beta? }#{ domain }/quality_control?locale=#{ I18n.locale }", target: "_new"
    links.push text: t("header.units_used") ,         url: "http://#{ "beta." if is_beta? }#{ domain }/units?locale=#{ I18n.locale }", target: "_new"
    links.push text: t("header.privacy_statement") ,  url: "http://#{ "beta." if is_beta? }#{ domain }/privacy?locale=#{ I18n.locale }", target: "_new"
    links.push text: t("header.disclaimer") ,         url: "http://#{ "beta." if is_beta? }#{ domain }/terms?locale=#{ I18n.locale }", target: "_new"
    links.push text: t("header.bugs") ,               url: "http://#{ "beta." if is_beta? }#{ domain }/known_issues?locale=#{ I18n.locale }", target: "_new"
    unless Settings.standalone
      links.push text: t("header.documentation") ,    url: "https://docs.energytransitionmodel.com", target: "_blank"
      links.push text: t("header.publications") ,     url: "http://refman.et-model.com", target: "_blank"
    end
    links.sort! {|x,y| x[:text] <=> y[:text] }
  end

  def ipad?
    request.env['HTTP_USER_AGENT'].downcase.index('ipad')
  rescue
    false
  end

  # Returns a hash of values which may be interpolated into description texts.
  def formatted_description_values
    @description_values ||= {
      etengine_url: Settings.api_url.to_s.chomp('/'),
      scenario_id:  Current.setting.api_session_id,
      area_code:    Current.setting.area_code,
      end_year:     Current.setting.end_year
    }.freeze
  end

  def format_description(text)
    if text
      values = formatted_description_values
      text.to_s.gsub(/%\{(\w+)\}/) { |token| values[token[2..-2].to_sym] }
    else
      text
    end
  end

  # Public: Receives a settings object and converts it to a hash suitable for
  # serialization as JSON.
  def settings_as_json(setting)
    setting.to_hash.merge(
      area_name: current_area_name,
      country_code: setting.area.top_level_area.area
    )
  end

  def active_saved_scenario_id
    Current.setting.active_saved_scenario_id
  end

  def save_scenario_enabled?
    Current.setting.active_saved_scenario_id.present?
  end

  def export_scenario_enabled?
    Current.setting.esdl_exportable
  end

  def back_url_or_root
    controller.request.env['HTTP_REFERER'].present? ? url_for(:back) : root_url
  end
end
