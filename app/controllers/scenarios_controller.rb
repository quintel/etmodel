require 'csv'

class ScenariosController < ApplicationController
  include MainInterfaceController.new(:play, :play_multi_year_charts)

  before_action :find_scenario, only: %i[show load play_multi_year_charts resume update_couplings coupling_settings inputs]
  before_action :require_user, only: %i[index merge]
  before_action :redirect_compare, only: :compare
  before_action :setup_comparison, only: %i[compare weighted_merge]
  before_action :store_last_etm_page, :prevent_browser_cache, only: :play
  before_action :myc_content_security_policy, only: :play_multi_year_charts

  # Raised when trying to save a scenario, but the user does not have a
  # scenario in progress. See quintel/etengine#542.
  class NoScenarioIdError < RuntimeError
    def initialize(controller)
      super(
        'Cannot save ETM scenario with settings: ' \
        "#{Current.setting.to_hash.inspect}"
      )
    end
  end

  rescue_from NoScenarioIdError do |ex|
    render :cannot_save_without_id, status: :bad_request
    Sentry.capture_exception(ex)
  end

  def index
    redirect_to "#{Settings.identity.issuer}/saved_scenarios", allow_other_host: true
  end

  def show
  end

  def confirm_reset
    if params[:inline]
      render 'reset', layout: false
    else
      render 'reset'
    end
  end

  def reset
    Current.setting.uncouple_scenario
    Current.setting.reset_scenario
    redirect_to_back
  end

  def coupling_settings
    if params[:inline]
      render 'coupling_settings_form', layout: false
    else
      render 'coupling_settings_form'
    end
  end

  # POST /scenarios/:id/update_couplings
  #
  # Updates the couplings of the scenario based on the form data.
  # The form data is a hash with the keys being the coupling group names and the
  # values being '1' or '0' for active or inactive.
  #
  # If the `remove_all_couplings` parameter is present, all couplings will be
  # removed.
  #
  def update_couplings
    permitted_params = params.permit(:remove_all_couplings, couplings: {})

    if permitted_params[:remove_all_couplings].present?
      Current.setting.uncouple_scenario
      UncoupleAPIScenario.call(engine_client, @scenario.id, soft: false)
    else
      couplings = permitted_params[:couplings] || {}
      active_couplings = couplings.select { |_, v| v == '1' }.keys
      inactive_couplings = couplings.select { |_, v| v == '0' }.keys

      if active_couplings.present?
        RecoupleAPIScenario.call(engine_client, @scenario.id, active_couplings)
        active_couplings.each { |group| Current.setting.activate_coupling(group) }
      end

      if inactive_couplings.present?
        UncoupleAPIScenario.call(engine_client, @scenario.id, inactive_couplings, soft: true)
        inactive_couplings.each { |group| Current.setting.deactivate_coupling(group) }
      end
    end

    redirect_back(fallback_location: root_path)
  end

  # Loads a scenario from a id.
  #
  # GET  /scenarios/:id/load
  # POST /scenarios/:id/load
  #
  def load
    scenario_attrs = { scenario_id: @scenario.id }

    Current.setting = Setting.load_from_scenario(@scenario)

    new_scenario = CreateAPIScenario.call(engine_client, scenario_attrs).or do
      flash[:error] = t('scenario.cannot_load')
      redirect_to(root_path)
      return
    end

    Current.setting.api_session_id = new_scenario.id

    redirect_to play_path
  end

  # This is the main scenario action
  #
  def play
    @selected_slide_key = @interface.current_slide.short_name
    respond_to do |format|
      format.html { render :play, layout: 'etm' }
      format.js
    end
  end

  # GET /scenario/resume/:id
  def resume
    Current.setting.reset!

    Current.setting = Setting.load_from_scenario(@scenario)
    Current.setting.api_session_id = @scenario.id

    redirect_to play_path
  end

  # A "synonym" of `play`, which acts as an entrypoint for the scenario editor
  # used by the multi-year charts interface.
  #
  # MYC loads the ETM in an iframe, which prohibits redirects; redirecting
  # causes the loss of session data when the visitor has third-party cookies
  # disabled.
  #
  # This action loads the requested scenario with a minimal interface,
  # optionally sending the user straight to a specific input.
  #
  # GET /scenario/myc/:id
  def play_multi_year_charts
    Current.setting.reset!

    Current.setting = Setting.load_from_scenario(@scenario)
    Current.setting.api_session_id = @scenario.id

    if params[:input] && (input = InputElement.find_by_key(params[:input]))
      Current.setting.last_etm_page = play_url(*input.url_components)
      @interface = Interface.new(*input.url_components)
    end

    @interface.variant = Interface::LiteVariant.new

    play
  end

  def inputs
    track_csv_download('inputs.csv')

    default_values = @scenario.inputs(engine_client)

    csv = CSV.generate do |row|
      row << [
        t("slides.data_export_inputs.headers.sidebar_item"),
        t("slides.data_export_inputs.headers.item_key"),
        t("slides.data_export_inputs.headers.title_for_description"),
        t("slides.data_export_inputs.headers.raw_key_title"),
        t("slides.data_export_inputs.headers.raw_key"),
        t("slides.data_export_inputs.headers.user_value"),
        t("slides.data_export_inputs.headers.min_value"),
        t("slides.data_export_inputs.headers.max_value"),
        t("slides.data_export_inputs.headers.default_value"),
        t("slides.data_export_inputs.headers.unit")
      ]

      InputElement.all.reject(&:area_dependent)
        .sort_by { |ie| [
          ie.slide.sidebar_item.tab_key,
          ie.slide.sidebar_item_key,
          ie.slide.title_for_description,
          ie.key
        ] }
        .each do |ie|
          value_attrs = default_values[ie.key] || {"min" => 0, "max" => 0, "default" => 0}

          row << [
            t("tabs.#{ie.slide.sidebar_item.tab_key}"),
            t("sidebar_items.#{ie.slide.sidebar_item_key}.title"),
            t(ie.slide.title_for_description),
            t("input_elements.#{ie.key}.title"),
            ie.key,
            @scenario.user_values[ie.key],
            value_attrs["min"],
            value_attrs["max"],
            value_attrs["default"],
            ie.unit
          ]
        end
    end

    send_data(
      "\uFEFF" + csv,
      type: "text/csv; charset=utf-8; header=present",
      disposition: "attachment; filename=inputs.#{@scenario.id}.csv"
    )
  end

  private

  def track_csv_download(type)
    Sentry.metrics.count(
      'csv_download',
      attributes: { type: type }
    )
  end

  # Finds the scenario from id
  def find_scenario
    @scenario = FetchAPIScenario.call(engine_client, params.require(:id).to_i).or do
      redirect_to root_path, notice: 'Scenario not found'
      return
    end

    unless @scenario.loadable?
      redirect_to root_path, notice: 'Sorry, this scenario cannot be loaded'
    end
  end

  # Remembers the most recently visited ETM page so that the visitor can be
  # brought back here if they reload, or return to the site later.
  def store_last_etm_page
    render_not_found && return unless @interface.current_tab

    tab_key     = @interface.current_tab.key
    sidebar_key = @interface.try(:current_sidebar_item).try(:key)
    slide_key   = @interface.try(:current_slide).try(:short_name)

    Current.setting.last_etm_page =
      play_url(tab_key, sidebar_key, slide_key)
  end

  def prevent_browser_cache
    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

  # Internal: For requests originating in the "multi-year charts" application,
  # we must permit pages to be loaded in an iframe.
  def myc_content_security_policy
    url = Settings.collections_url

    return unless url

    response.set_header('X-Frame-Options', "allow-from #{url}")
    response.set_header('Content-Security-Policy', "frame-ancestors #{url}")
  end
end
