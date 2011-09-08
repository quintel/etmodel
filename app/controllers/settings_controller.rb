class SettingsController < ApplicationController
  layout 'etm'

  before_filter :ensure_valid_browser

  def edit
  end

  def update
    [:api_session_id, :network_parts_affected, :track_peak_load, :use_fce].each do |setting|
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

end
