class PagesController < ApplicationController
  include ApplicationHelper
  before_action :ensure_valid_browser, except: [:browser_support]
  layout 'static_page', only: [:about, :units, :browser_support, :bugs,
    :disclaimer, :privacy_statement, :quality, :dataset]

  def root
    if request.post?
      assign_settings_and_redirect
    else
      setup_countries_and_regions
    end
  end

  def scaled
    setup_countries_and_regions
  end

  def dataset
    unless @area = Api::Area.find_by_country_memoized(params[:dataset_locale])
      fail ActiveRecord::RecordNotFound
    end
  end

  def choose
    @mixer_url = (APP_CONFIG[:mixer_url] || "http://mixer.et-model.com") +
      "?locale=#{I18n.locale}"
    @etflex_url = APP_CONFIG[:etflex_url] || "http://light.energytransitionmodel.com"

    render layout: 'refreshed'
    @other_locale = english? ? "nl" : "en"
  end

  # Popup with the text description. This is confusing because the title can
  # be defined in a Text object or in the standard translation files, while
  # the description is a normal description object.
  #
  def info
    ctrl = params[:ctrl]
    act  = params[:act]
    # The description belongs to a sidebar item. Ugly!
    s = SidebarItem.find_by_section_and_key(ctrl, act)

    # The title is stored in an object
    @title = Text.find_by_key("#{ctrl}_#{act}").try(:title) ||
      t("sidebar_items.#{s.key}.long_name") rescue nil

    @description = s.description.try(:content) if s
    render layout: false
  end

protected

  def setup_countries_and_regions
    @show_all = session[:show_municipalities] || session[:show_all_countries]
    @show_german_provinces = (current_user.try(:email) == "brandenburg@et-model.com" || session[:show_all_countries])
  end

  def assign_settings_and_redirect
    Current.setting = Setting.default
    Current.setting.end_year = (params[:end_year] == "other") ? params[:other_year] : params[:end_year]
    Current.setting.area_code = params[:area_code]
    Current.setting.preset_scenario_id = params[:preset_scenario_id]

    assign_scaling_attributes(params)

    redirect_to play_path and return
  end

public

  def update_footer
    render partial: "layouts/etm/footer"
  end

  def show_all_countries
    session[:show_all_countries] = true
    redirect_to root_path
  end

  def show_flanders
    session[:show_flanders] = true
    redirect_to root_path
  end

  def prominent_users
    @users = YAML::load_file('config/prominent_users.yml').sort_by{rand()}
  end

  def quality
    @quality = Text.where(key: :quality_control).first
  end

  def feedback
    if params[:feedback]
      if /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i.match(params[:feedback][:email])
        request.format = 'js' # to render the js.erb template
        @options = params[:feedback]
        Notifier.feedback_mail(@options).deliver
        Notifier.feedback_mail_to_sender(@options).deliver
      else
        @errors = true
      end
    else
      render layout: false
    end
  end

  def tutorial
    loc = I18n.locale
    @tab = params[:tab]
    @vimeo_id_for_tab =  Tab.find_by_key(@tab).try("#{loc}_vimeo_id")
    @sidebar = params[:sidebar]
    @vimeo_id_for_sidebar = SidebarItem.find_by_key(@sidebar).try("#{loc}_vimeo_id")
    render layout: false
  end

  def set_locale
    locale
    redirect_to_back
  end
end
