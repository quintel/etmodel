module ApplicationHelper
  def has_active_scenario?
    Current.setting.api_session_id.present? || @active_scenario
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

  # Returns the constraints which belong to the given `group`.
  #
  # This method will actually fetch and cache all constraints, assuming that
  # you will eventually want the constraints for all the other groups anyway.
  #
  # Used in views/constraints/_changer.html
  #
  # @param  [String] group The name of the group.
  # @return [Array(Constraint)]
  #
  def constraints_for_group(group)
    @_grouped_constraints ||= Constraint.enabled.group_by(&:group)
    @_grouped_constraints[group]
  end

  # Used to show a notice in the admin section
  #
  def live_server?
    APP_CONFIG[:live_server]
  end

  def live_server_type
    if APP_CONFIG[:live_server].is_a?(String)
      APP_CONFIG[:live_server]
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
    unless APP_CONFIG[:standalone]
      links.push text: t("header.documentation") ,    url: "https://github.com/quintel/documentation", target: "_blank"
      links.push text: t("header.publications") ,     url: "http://refman.et-model.com", target: "_blank"
      links.push text: t("header.feedback") ,         url: feedback_path, class: "fancybox"
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
      etengine_url: APP_CONFIG[:api_url].to_s.chomp('/'),
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
      area_scaling: setting.area.try(:scaling)
    )
  end

  def active_saved_scenario_id
    Current.setting.active_saved_scenario_id
  end

  def save_scenario_enabled?
    Current.setting.active_saved_scenario_id.present?
  end
end
