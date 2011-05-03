class SettingsController < ApplicationController
  layout 'etm'

  before_filter :ensure_valid_browser

  def edit

  end

  def update
    if ! params[:show_municipality_introduction].nil?
      Current.setting.show_municipality_introduction = false
    end
    
    
    if year = params[:end_year] and year[/\d{4}/]
      Current.scenario.end_year = year.to_i
      flash[:notice] = "#{I18n.t("flash.end_year")} #{Current.scenario.end_year}."
    end
    if params[:track_peak_load] != nil
      Current.setting.track_peak_load = params[:track_peak_load] == 'true'
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render :text => '', :status => 200}
    end
  end

end
