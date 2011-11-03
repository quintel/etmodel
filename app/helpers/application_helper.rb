module ApplicationHelper
  include SortableTable::App::Helpers::ApplicationHelper  

  def asset_cache_name(name)
    if Rails.env.development?
      # we set config.perform_caching to true in development (to cache the Graph-qernel)
      # so we have to return false, otherwise changes won't be dodated
      false
    else
      "cache_#{name}"
    end
  end

  def has_active_scenario?
    Current.setting.api_session_id.present?
  end

  def strip_html(str)
    # see: http://snippets.dzone.com/posts/show/4324
    str.gsub(/<\/?[^>]*>/, "")
  end


  # TODO: get rid of this, use CSS
  def table_defaults
    {:cellspacing => 0, :cellpadding => 0, :border => 0, :class => 'default'}
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

  def last_etm_path(options = {})
    options[:include_action] = true unless options.has_key?(:include_action)
    if options[:include_action]
     "#{Current.setting.last_etm_controller_name}/#{Current.setting.last_etm_controller_action}"
    else
      Current.setting.last_etm_controller_name
    end
  end

  def t_db(key)
    begin
      Translation.find_by_key(key).content.html_safe
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
end
