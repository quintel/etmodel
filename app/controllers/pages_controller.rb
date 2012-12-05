class PagesController < ApplicationController
  include ApplicationHelper
  before_filter :ensure_valid_browser, :except => [:browser_support, :disable_browser_check]
  layout 'static_page', :only => [:about, :units, :browser_support, :bugs,
    :disclaimer, :privacy_statement]

  def root
    if request.post?
      assign_settings_and_redirect
    else
      setup_countries_and_regions
    end
  end

  def choose
    if request.post?
      assign_settings_and_redirect
    else
      render layout: 'refreshed'
      @other_locale = english? ? "nl" : "en"
    end
  end

  # popup with the text description
  def info
    # The title is stored in an object
    @title = Text.find_by_key("#{params[:ctrl]}_#{params[:act]}").try :title
    # The description belongs to a sidebar item. Ugly!
    s = SidebarItem.find_by_section_and_key(params[:ctrl], params[:act])
    @description = s.description.try(:content) if s
    render :layout => false
  end

protected

  def setup_countries_and_regions
    @show_all = session[:show_municipalities] || session[:show_all_countries]
    @show_german_provinces = (current_user.try(:email) == "brandenburg@et-model.com" || session[:show_all_countries])
  end

  def assign_settings_and_redirect
    session[:dashboard] = nil
    Current.setting = Setting.default
    Current.setting.end_year = (params[:end_year] == "other") ? params[:other_year] : params[:end_year]
    Current.setting.area_code = params[:area_code]
    redirect_to play_path and return
  end

public

  def press_releases
    @releases = PressRelease.order("release_date desc")
  end

  def update_footer
    render :partial => "layouts/etm/footer"
  end

  def show_all_countries
    session[:show_all_countries] = true
    redirect_to home_path
  end

  def show_flanders
    session[:show_flanders] = true
    redirect_to home_path
  end

  def disable_browser_check
    session[:disable_browser_check] = true
    redirect_to home_path
  end

  def enable_browser_check
    session[:disable_browser_check] = false
    redirect_to home_path
  end

  def famous_users
    @users = YAML::load_file('config/famous_users.yml').sort_by{rand()}
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
      render :layout => false
    end
  end

  def tutorial
    loc = I18n.locale
    @tab = params[:tab]
    @vimeo_id_for_tab =  Tab.find_by_key(@tab).try("#{loc}_vimeo_id")
    @sidebar = params[:sidebar]
    @vimeo_id_for_sidebar = SidebarItem.find_by_key(@sidebar).try("#{loc}_vimeo_id")
    render :layout => false
  end

  def set_locale
    locale
    redirect_to_back
  end
end
