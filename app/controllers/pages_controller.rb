class PagesController < ApplicationController
  include ApplicationHelper

  skip_before_action :ensure_modern_browser, only: [:unsupported_browser]

  layout 'static_page', only: :dataset
  layout 'landing', only: :root

  def root
    if request.post?
      assign_settings_and_redirect
    else
      setup_countries_and_regions
    end
  end

  def dataset
    @area = Api::Area.find_by_country_memoized(params[:dataset_locale])
    raise ActiveRecord::RecordNotFound unless @area

    @time = params[:time] if %w[present future].include?(params[:time])
    @time ||= 'present'
    @year = Current.setting.end_year if @time == 'future'
    @year ||= @area.analysis_year
  end

  def unsupported_browser
    render layout: 'form_only'
  end

  def update_footer
    render partial: "layouts/etm/footer"
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
end
