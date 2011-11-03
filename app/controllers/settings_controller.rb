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
    session[:dashboard] ||= []
    incoming = params[:dash] and params[:dash].dup

    if incoming.kind_of?(Hash)
      keys = DASHBOARD_KEYS.map { |key| incoming[key] }

      # Assert that the keys are valid; exceptions are raised (and caught
      # below) otherwise.
      Constraint.for_dashboard(keys) # raises if keys aren't valid

      session[:dashboard] = keys
    end

    render json: session[:dashboard], status: :ok

  rescue Constraint::IllegalConstraintKey
    render json: { error: 'Invalid constraints' }, status: :bad_request

  rescue Constraint::NoSuchConstraint => e
    render json: { error: e.message }, status: :bad_request
  end

end
