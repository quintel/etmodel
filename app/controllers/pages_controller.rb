class PagesController < ApplicationController
  layout 'pages'
  include ApplicationHelper
  before_filter :ensure_valid_browser, :except => [:browser_support, :disable_browser_check]
  before_filter :defaults
  skip_before_filter :show_intro_screens_only_once, :only => [:intro]

  def root
    all_views = Current.setting.all_levels.map{|id, name| [t("views.#{name}"), id]}
    @scenario_levels = if Rails.env.development? || Rails.env.test?
      all_views
    else
      all_views[0..2]
    end

    # if user wanted to start with a new scenario
    if params[:end_year]
      Current.setting = Setting.default
      Current.setting.end_year = (params[:end_year] == "other") ? params[:other_year] : params[:end_year]
      Current.setting.complexity = params[:complexity]
      country = params[:region].split("-").first
      Current.setting.set_country_and_region(country, params[:region]) # we need the full region code here

      if Current.setting.municipality?
        redirect_to :action => "municipality" and return
      else
        redirect_to :controller => 'pages', :action => 'intro'
      end  
    end

    @scenarios = Api::Scenario.all(:from => :homepage)
  end

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
  
  # intro screen for municipalitities
  # in the view a preset scenario will be loaded.
  def municipality
    @scenarios = Api::Scenario.all(:from => :homepage)
    if current_user
      @user_scenarios = current_user.scenarios.by_region('nl').order("updated_at DESC") #if current_user.andand.scenarios.by_region('nl')
    end
    # raise @user_scenarios.inspect
    @area = Current.setting.region

    if request.post?
      Current.setting.hide_unadaptable_sliders = params[:hide_unadaptable_sliders] == "1"
      if params[:scenario]
        @scenario = Api::Scenario.find(params[:scenario])
        # must never occur, unless someone tries to load another scenario
        raise HTTPStatus::Forbidden if @scenario.user.nil? && @scenario.user != current_user
        # TODO seb: help what is this?? :municipality_preset??
        @scenario.load_scenario(:municipality_preset => true)
      end
      redirect_to(:controller => 'pages', :action => 'intro') and return
    end
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

  def municipalities
    session[:show_municipalities] = true
    redirect_to '/'
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
