class PagesController < ApplicationController
  include ApplicationHelper
  before_filter :ensure_valid_browser, :except => [:browser_support, :disable_browser_check]
  before_filter :defaults
  skip_before_filter :show_intro_screens_only_once, :only => [:intro]

  def root
    if request.post?
      assign_settings_and_redirect
    else
      setup_countries_and_regions
    end
  end

  # This page is called by the ETE after an ETSource import
  # DEBT: find a safer way
  def flush_cache
    Rails.cache.clear
    render :text => 'ok', :layout => false
  end

  def choose
    if request.post?
      assign_settings_and_redirect
    else
      render layout: 'refreshed'
      @other_locale = ( I18n.locale == :en ? "nl" : "en" )
    end
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
    redirect_to :controller => 'pages', :action => 'intro' and return
  end

public

  def grid_investment_needed
    render :layout => false
  end

  def intro
    @render_tabs = true
  end

  def press_releases
    @releases = PressRelease.order("release_date desc")
  end

  def education
    @ie_detected = browser =~ /^ie/
  end

  def update_footer
    render :partial => "layouts/etm/footer"
  end

  def select_movie
    request.format = 'js'
    # check view
  end

  def show_all_countries
    session[:show_all_countries] = true
    redirect_to '/'
  end

  def show_flanders
    session[:show_flanders] = true
    redirect_to root_path
  end

  # Use this action to toggle wattnu features
  # (score, round, etc)
  def wattnu_on
    session[:wattnu] = true
    redirect_to root_path, :notice => "Watt Nu score feature is now set to #{session[:wattnu]}"
  end

  def wattnu_off
    session[:wattnu] = false
    redirect_to root_path, :notice => "Watt Nu score feature is now set to #{session[:wattnu]}"
  end

  def bugs
    @translation = Translation.find_or_create_by_key('bugs')
  end

  ######################################
  # Browser Checks
  ######################################

  def browser_support
  end

  def disable_browser_check
    session[:disable_browser_check] = true
    redirect_to '/'
  end

  def enable_browser_check
    session[:disable_browser_check] = false
    redirect_to '/'
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
    @section = params[:section]
    @vimeo_id_for_section =  Tab.find_by_key(@section).send("#{I18n.locale}_vimeo_id")
    @category = params[:category]
    @vimeo_id_for_category = SidebarItem.find_by_key(@category).send("#{I18n.locale}_vimeo_id")
    render :layout => false
  end

private

  # ?? - PZ
  def defaults
    @render_tabs = false
  end
end
