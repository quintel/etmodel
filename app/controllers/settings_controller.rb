class SettingsController < ApplicationController
  layout 'etm'

  before_filter :ensure_valid_browser

  def edit
  end

  def update
    if ! params[:show_municipality_introduction].nil?
      Current.setting.show_municipality_introduction = false
    end

    [:api_session_key, :network_parts_affected, :track_peak_load, :use_fce].each do |setting|
      Current.setting.send("#{setting}=", params[setting]) unless params[setting].nil?
    end

    if year = params[:end_year].to_s and year[/\d{4}/]
      if Current.setting.end_year != year.to_i
        Current.setting.end_year = year.to_i
        flash[:notice] = "#{I18n.t("flash.end_year")} #{Current.setting.end_year}."
      end
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render :text => '', :status => 200}
      format.json { render :json => Current.setting }
    end
  end

  # Temporary, to be removed when the backcasting will be enabled in production
  # PZ - Tue 19 Jul 2011 14:48:08 CEST
  def backcasting
    session[:enable_backcasting] = true
    flash[:notice] = "Backcasting enabled"
    redirect_to root_path and return
  end
end
