class SettingsController < ApplicationController
  layout 'etm'

  before_filter :ensure_valid_browser

  def edit

  end

  def update
    if ! params[:show_municipality_introduction].nil?
      Current.setting.show_municipality_introduction = false
    end

    [:network_parts_affected, :track_peak_load].each do |setting|
      Current.setting.send("#{setting}=", params[setting]) unless params[setting].nil?
    end

    if year = params[:end_year].to_s and year[/\d{4}/]
      Current.scenario.end_year = year.to_i
      flash[:notice] = "#{I18n.t("flash.end_year")} #{Current.scenario.end_year}."
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render :text => '', :status => 200}
      format.json { render :json => Current.setting }
    end
  end

end
