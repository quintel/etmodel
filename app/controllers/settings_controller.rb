class SettingsController < ApplicationController
  layout 'etm'

  skip_before_action :verify_authenticity_token, only: :update

  def edit
  end

  def update
    setting_params = params.permit(
      :api_session_id,
      :end_year,
      :network_parts_affected,
      locked_charts: Array(params[:locked_charts].try(:keys))
    )

    [ :api_session_id,
      :network_parts_affected,
      :locked_charts].each do |setting|
      Current.setting.send("#{setting}=", setting_params[setting]) unless params[setting].nil?
    end

    if year = params[:end_year].to_s and year[/\d{4}/]
      if Current.setting.end_year != year.to_i
        Current.setting.end_year = year.to_i
      end
    end

    respond_to do |format|
      format.html { redirect_to_back }
      format.json { render json: Current.setting }
    end
  end

  # Renders an HTML string which is used by the Backbone View to show the
  # dashboard changer.
  #
  # GET /settings/dashboard
  #
  def dashboard
    dash = session[:dashboard]

    dashboard_items = if dash&.any?
      DashboardItem.for_dashboard(dash)
    else
      DashboardItem.ordered_default
    end.reject(&:not_allowed_in_this_area)

    @checked = dashboard_items.map(&:key)

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
    unless params[:dash]&.respond_to?(:to_h)
      render(
        json: { error: 'Invalid dashboard_items hash' },
        status: :bad_request
      )
      return
    end

    keys = DashboardItem::GROUPS.map { |key| params[:dash][key] }

    # Assert that the keys are valid; exceptions are raised (and caught
    # below) otherwise.
    dashboard_items = DashboardItem
      .for_dashboard!(keys)
      .reject(&:not_allowed_in_this_area)

    session[:dashboard] = keys

    render status: :ok, json: {
      dashboard_items: dashboard_items,
      html: dashboard_item_html_as_json(dashboard_items)
    }
  rescue DashboardItem::IllegalDashboardItemKey
    render(json: { error: 'Invalid dashboard items' }, status: :bad_request)
  rescue DashboardItem::NoSuchDashboardItem => e
    render(json: { error: e.message }, status: :bad_request)
  end


  # Records that the user has hidden the "results tip" which advises them of
  # the results/data section.
  #
  # The user may hide the tip for a specific scenario (given as a paramter) or
  # for all scenarios.
  #
  # PUT /settings/hide_results_tip
  #
  def hide_results_tip
    scenario_id =
      if params[:scenario_id].to_s.match(/\A\d+\z/)
        params[:scenario_id].to_i
      else
        :all
      end

    if scenario_id == :all && current_user
      current_user.update_attribute(:hide_results_tip, true)
      session.delete(:hide_results_tip)
    else
      session[:hide_results_tip] = scenario_id
    end

    render json: {}, status: :ok
  end

  #######
  private
  #######

  # Renders the dashboard item items partial based on the newly selected
  # dashboard items so that the Backbone View may re-render the dashboard.
  #
  def dashboard_item_html_as_json(dashboard_items)
    render_to_string(
      'layouts/etm/_dashboard_items',
      layout: false,
      locals: { dashboard_items: dashboard_items }
    )
  end

end
