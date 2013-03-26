module ApplicationHelper
  def has_active_scenario?
    Current.setting.api_session_id.present? || @active_scenario
  end

  def flash_message(type = nil)
    if type.nil?
      flash_message(:notice) if flash[:notice]
      flash_message(:error) if flash[:error]
    else
      haml_tag 'div#flash', :class => type.to_s do
        haml_tag :p do
          haml_concat flash[type]
          haml_tag :small, link_to('close', '#', :onclick => "$('#flash').hide();")
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

  def to_yml_syntax(title)
    title.parameterize.underscore.to_sym
  end

  def information_links
    links = []
    links.push text: t("header.partners") ,           url: partners_path
    links.push text: t("header.about_qi") ,           url: "http://quintel.com", target: "_new"
    links.push text: t("header.education") ,          url: "http://onderwijs.quintel.nl/", target: "_new"
    links.push text: t("header.famous_users") ,       url: famous_users_path
    links.push text: t("header.press_releases") ,     url: press_releases_path
    links.push text: t("header.units_used") ,         url: units_path
    links.push text: t("header.privacy_statement") ,  url: privacy_statement_path
    links.push text: t("header.disclaimer") ,         url: disclaimer_path
    links.push text: t("header.bugs") ,               url: bugs_path
    unless APP_CONFIG[:standalone]
      links.push text: "Wiki" ,                       url: "http://wiki.quintel.com", target: "_blank"
      links.push text: t("header.publications") ,     url: "http://refman.et-model.com", target: "_blank"
      links.push text: t("header.feedback") ,         url: feedback_path, class: "fancybox"
    end
    links.sort! {|x,y| x[:text] <=> y[:text] }
  end

end
