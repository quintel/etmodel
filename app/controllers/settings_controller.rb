class SettingsController < ApplicationController

  # Keys for each "constraint type" in the dashboard.
  #
  # @return [Array<String>]
  #
  DASHBOARD_KEYS = %w(
    energy emissions imports costs bio renewables goals
  ).freeze

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
      format.html { redirect_to_back }
      format.js { render :text => '', :status => 200}
      format.json { render :json => Current.setting }
    end
  end

  # Updates the user's dashboard preferences. Stores those preferences in the
  # session for now; we can move it to the DB later if permanently storing
  # them is preferable.
  #
  # JSON only.
  #
  # PUT /settings/dashboard
  #
  def dashboard
    session[:dashboard] ||= {}.with_indifferent_access
    incoming = params[:dash] and params[:dash].dup

    if incoming.kind_of?(Hash)
      incoming.reject { |k, v| not DASHBOARD_KEYS.include?(k) or v.blank? }

      constraint_ids = incoming.values
      constraint_ids.uniq!

      if Constraint.where(id: constraint_ids).count < constraint_ids.length
        # Make sure that we were given valid constraint IDs (otherwise
        # subsequent page loads will 404 due to the invalid ID).
        render json: { error: 'Invalid constraint ID' }, status: :bad_request
        return
      end

      session[:dashboard].merge!(incoming)
    end

    render json: session[:dashboard], status: :ok
  end

end
