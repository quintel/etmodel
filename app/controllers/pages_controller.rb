class PagesController < ApplicationController
  layout 'pages'
  include ApplicationHelper
  before_filter :ensure_valid_browser, :except => [:browser_support, :disable_browser_check]
  before_filter :defaults
  skip_before_filter :show_intro_screens_only_once, :only => [:intro]

  def root
    if params[:end_year]
      assign_settings_and_redirect
    else
      show_root_page
    end
  end

  # This page is called by the ETE after an ETSource import
  # DEBT: find a safer way
  def flush_cache
    Rails.cache.clear
    render :text => 'ok', :layout => false
  end

protected

  def setup_countries_and_regions
    @show_all = session[:show_municipalities] || session[:show_all_countries]
    @show_german_provinces = (current_user.try(:email) == "brandenburg@et-model.com" || session[:show_all_countries])
  end

  def show_root_page
    setup_countries_and_regions
    all_views = Current.setting.all_levels.map{|id, name| [t("views.#{name}"), id]}
    @scenario_levels = if Rails.env.development? || Rails.env.test?
      all_views
    else
      all_views[0..2]
    end
  end

  def assign_settings_and_redirect
    Current.setting = Setting.default
    Current.setting.complexity = params[:complexity]
    Current.setting.end_year = (params[:end_year] == "other") ? params[:other_year] : params[:end_year]
    Current.setting.set_country_and_region_from_param(params[:region]) # we need the full region code here

    redirect_to :controller => 'pages', :action => 'intro' and return
  end

public

  def grid_investment_needed
    render :layout => false
  end

  def intro
    @render_tabs = true
    render :layout => 'pages'
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
    render :update do |page|
      page["#movie_content"].html(render 'movie', :page => params[:id])
      page.call('set_active_tab', params[:id])
    end
  end

  def show_all_countries
    session[:show_all_countries] = true
    redirect_to '/'
  end

  def show_all_views
    session[:show_all_views] = true
    redirect_to '/'
  end

  def show_flanders
    session[:show_flanders] = true
    redirect_to root_path
  end

  # Use this action to toggle wattnu features
  # (score, round, etc)
  def wattnu
    session[:wattnu] = !session[:wattnu]
    redirect_to root_path, :notice => "Watt Nu score feature is now set to #{session[:wattnu]}"
  end

  ######################################
  # Browser Checks
  ######################################

  def browser_support
    render :layout => 'pages'
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
        @options = params[:feedback]
        spawn do #use spawn to create a bg process for sending mail
          Notifier.feedback_mail(@options).deliver
          Notifier.feedback_mail_to_sender(@options).deliver
        end

        render :update do |page|
          page.call "$.fancybox.close"
          page.call "flash_notice", t("feedback_confirm")
        end
      else
        render :update do |page|
           page['#errors'].html(t("feedback_error"))
         end
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

  def defaults
    @render_tabs = false
  end

end
