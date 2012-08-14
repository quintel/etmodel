module ApplicationHelper
  def has_active_scenario?
    Current.setting.api_session_id.present? || @active_scenario
  end

  # TODO: get rid of this, use CSS
  def cycles(html_attrs = {})
    class_name = cycle('odd', 'even')
    html_attrs[:class] = "#{html_attrs[:class]} #{class_name}"
    html_attrs
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
    @_grouped_constraints ||= Constraint.all.group_by(&:group)
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
    links.push({ "text" => t("header.partners") , "link" => partners_path, "target" => nil , "class" => nil})
    links.push({ "text" => t("header.about_qi") , "link" => about_path, "target" => nil , "class" => nil})
    links.push({ "text" => t("header.education") , "link" => "http://onderwijs.quintel.nl/", "target" => "_new" , "class" => nil})
    links.push({ "text" => t("header.famous_users") , "link" => famous_users_path, "target" => nil , "class" => nil})
    links.push({ "text" => t("header.press_releases") , "link" => press_releases_path, "target" => nil , "class" => nil})
    links.push({ "text" => t("header.units_used") , "link" => units_path, "target" => nil , "class" => nil})
    links.push({ "text" => t("header.privacy_statement") , "link" => privacy_statement_path, "target" => nil , "class" => nil})
    links.push({ "text" => t("header.disclaimer") , "link" => disclaimer_path, "target" => nil , "class" => nil})
    links.push({ "text" => t("header.bugs") , "link" => bugs_path, "target" => nil , "class" => nil})
    unless APP_CONFIG[:standalone]
      links.push({ "text" => "Wiki" , "link" => "http://wiki.quintel.com", "target" => "_blank" , "class" => nil})
      links.push({ "text" => t("header.publications") , "link" => "http://refman.et-model.com", "target" => "_blank" , "class" => nil})
      links.push({ "text" => t("header.feedback") , "link" => feedback_path, "target" => nil , "class" => "fancybox"})
    end
    links.sort! {|x,y| x["text"] <=> y["text"] }
  end

end