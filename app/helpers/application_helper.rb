module ApplicationHelper
  include SortableTable::App::Helpers::ApplicationHelper  

  def asset_cache_name(name)
    if Rails.env.development? || Rails.env.builded?
      # we set config.perform_caching to true in development (to cache the Graph-qernel)
      # so we have to return false, otherwise changes won't be dodated
      false
    else
      "cache_#{name}"
    end
  end

  def has_active_scenario?
    #RD: renamed from has_update_statements?
    Current.setting.api_session_key.present?
  end

  def strip_html(str)
    # see: http://snippets.dzone.com/posts/show/4324
    str.gsub(/<\/?[^>]*>/, "")
  end


  def table_defaults
    {:cellspacing => 0, :cellpadding => 0, :border => 0, :class => 'default'}
  end

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
    options[:include_action] = true if !options.has_key?(:include_action)
    if options[:include_action]
     "%s/%s" % [Current.setting.last_etm_controller_name, Current.setting.last_etm_controller_action]
    else
      "%s" % [Current.setting.last_etm_controller_name]
    end
  end

  def t_db(key)
    begin
      Translation.find_by_key(key).content.html_safe
    rescue
      "translation missing, #{I18n.locale.to_s.split('-').first} #{key}"
    end
  end
end
