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
      result = FetchFeaturedScenarios.call(my_etm_client)

      @featured_scenarios = if result.successful?
        MyEtm::FeaturedScenario.in_groups_per_end_year(
          result.value.map { |data| MyEtm::FeaturedScenario.new(data) }
        )
      else
        []
      end
    end
  end

  def dataset
    @area = Engine::Area.find_by_country_memoized(params[:dataset_locale])
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

  def set_locale
    locale
    render(plain: '', status: :ok)
  end

  # ETEngine redirects to this endpoint when the user is deleted. We show a notification to the user
  # but no deletion is performed in this action since responds to a GET request.
  def account_deleted
    reset_session
    flash[:notice] = I18n.t('flash.account_deleted')
    redirect_to root_path
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
