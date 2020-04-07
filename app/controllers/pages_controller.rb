class PagesController < ApplicationController
  include ApplicationHelper
  before_action :ensure_valid_browser, except: [:browser_support]
  layout 'static_page', only: [:about, :units, :browser_support, :bugs,
    :disclaimer, :privacy_statement, :quality, :dataset]

  layout 'landing', only: :root

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
    @area = Api::Area.find_by_country_memoized(params[:dataset_locale])
    raise ActiveRecord::RecordNotFound unless @area

    @time = params[:time] if %w[present future].include?(params[:time])
    @time ||= 'present'
    @year = Current.setting.end_year if @time == 'future'
    @year ||= @area.analysis_year
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

    @description = s.description
    render layout: false
  end

  def whats_new
  end

protected

  def setup_countries_and_regions
    @show_all = session[:show_municipalities] || session[:show_all_countries]
    @show_german_provinces = (current_user.try(:email) == "brandenburg@et-model.com" || session[:show_all_countries])
  end

  def assign_settings_and_redirect
    Current.setting = Setting.default
    Current.setting.end_year = params[:end_year]
    Current.setting.area_code = params[:area_code]
    Current.setting.preset_scenario_id = params[:preset_scenario_id]

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

  def quality
    @quality = Text.where(key: :quality_control).first
  end

  def feedback
    if params[:feedback]
      if /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i.match(params[:feedback][:email])
        request.format = 'js' # to render the js.erb template
        @options = params[:feedback]
        Notifier.feedback_mail(@options).deliver
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
    render(plain: '', status: :ok)
  end
end
