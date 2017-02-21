class SettingsController < ApplicationController
  layout 'etm'

  before_action :ensure_valid_browser
  skip_before_action :verify_authenticity_token, :only => :update

  def edit
  end

  def update
    setting_params = params.permit(
      :api_session_id,
      :track_peak_load,
      :use_fce,
      :end_year,
      :network_parts_affected,
      locked_charts: Array(params[:locked_charts].try(:keys))
    )

    [ :api_session_id,
      :network_parts_affected,
      :track_peak_load,
      :use_fce,
      :locked_charts].each do |setting|
      Current.setting.send("#{setting}=", setting_params[setting]) unless params[setting].nil?
    end

    if year = params[:end_year].to_s and year[/\d{4}/]
      if Current.setting.end_year != year.to_i
        Current.setting.end_year = year.to_i
        flash[:notice] = "#{I18n.t("flash.end_year")} #{Current.setting.end_year}."
      end
    end

    respond_to do |format|
      format.html { redirect_to_back }
      format.json { render :json => Current.setting }
    end
  end

  # Renders an HTML string which is used by the Backbone View to show the
  # dashboard changer.
  #
  # GET /settings/dashboard
  #
  def dashboard
    dash = session[:dashboard]

    constraints = if dash and dash.any?
      Constraint.for_dashboard(dash)
    else
      Constraint.enabled.default.ordered
    end.reject(&:not_allowed_in_this_area)

    @checked = constraints.map(&:key)

    render layout: false
  end

  # Updates the user's dashboard preferences. Stores those preferences in the
  # session for now; we can move it to the DB later if permanently storing
  # them is preferable.
  #
  # JSON only.
  #
  # PUT /settings/dashboard
  #
  def update_dashboard
    unless params[:dash]
      render json: { error: 'Invalid constraints hash' }, status: :bad_request
      return
    end

    keys = Constraint::GROUPS.map { |key| params[:dash][key] }

    # Assert that the keys are valid; exceptions are raised (and caught
    # below) otherwise.
    constraints = Constraint.for_dashboard(keys).reject(&:not_allowed_in_this_area)

    session[:dashboard] = keys

    render status: :ok, json: {
      constraints: constraints,
      html:        constraint_html_as_json(constraints) }

  rescue Constraint::IllegalConstraintKey
    render json: { error: 'Invalid constraints' }, status: :bad_request

  rescue Constraint::NoSuchConstraint => e
    render json: { error: e.message }, status: :bad_request
  end

  #######
  private
  #######

  # Renders the constraint items partial based on the newly selected
  # constraints so that the Backbone View may re-render the dashboard.
  #
  def constraint_html_as_json(constraints)
    render_to_string 'layouts/etm/_dashboard_items',
      layout: false, locals: { constraints: constraints }
  end

end
