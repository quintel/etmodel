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

  def ipad?
    request.env['HTTP_USER_AGENT'].downcase.index('ipad')
  rescue
    false
  end

  # Returns a hash of values which may be interpolated into description texts.
  def formatted_description_values
    @description_values ||= {
      etengine_url: Settings.ete_url.to_s.chomp('/'),
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

  # Public: returns true if the sliders are a mix of coupling and
  # ordinary sliders
  def mixed_coupled?(sliders)
    sliders.any?(&:coupling_icon) && !sliders.all?(&:coupling_icon)
  end

  # Public: Receives a settings object and converts it to a hash suitable for
  # serialization as JSON.
  def settings_as_json(setting)
    setting.to_hash.merge(
      area_name: current_area_name,
      country_code: setting.area.country_area.area
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

  # Public: Returns if a asset exists at the specified path.
  def asset_exists?(path)
    if Rails.configuration.assets.compile
      !Rails.application.assets.find_asset(path).nil?
    else
      !Rails.application.assets_manifest.assets[path].nil?
    end
  end

  def js_globals
    Jbuilder.encode do |json|
      json.ete_url          Settings.ete_url
      json.idp_url          Settings.identity.issuer
      json.api_proxy_url    Settings.api_proxy_url
      json.disable_cors     Settings.disable_cors
      json.standalone       Settings.standalone
      json.settings         settings_as_json(Current.setting)
      json.debug_js         admin?
      json.env              Rails.env
      json.charts_enabled   @interface && @interface.variant.charts?

      if current_user
        json.user do
          json.id   current_user.id
          json.name current_user.name
        end

        json.access_token do
          json.token identity_access_token.token
          json.expires_at identity_access_token.expires_at
        end
      else
        json.current_user nil
        json.access_token nil
      end

      if Current.setting.active_scenario?
        json.api_session_id Current.setting.api_session_id
      else
        json.api_session_id nil
      end
    end.html_safe
  end
end
