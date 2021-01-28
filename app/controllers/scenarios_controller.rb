class ScenariosController < ApplicationController
  include MainInterfaceController.new(:play, :play_multi_year_charts)

  before_action :find_scenario, only: %i[show load play_multi_year_charts]
  before_action :require_user, only: %i[index new merge]
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
    Raven.capture_exception(ex)
  end

  def index
    @student_ids = current_user.students.pluck(:id)
    items = if current_user.admin?
      SavedScenario.all.includes(:featured_scenario, :user)
    elsif current_user.students.present?
      SavedScenario.includes(:featured_scenario, :user)
        .where(user_id: @student_ids + [current_user.id])
    else
      current_user.saved_scenarios
    end
    @saved_scenarios = items.order('updated_at DESC').page(params[:page]).per(50)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  end

  def reset
    Current.setting.reset_scenario
    redirect_to_back
  end

  # Loads a scenario from a id.
  #
  # GET  /scenarios/:id/load
  # POST /scenarios/:id/load
  #
  def load
    scenario_attrs = { scenario_id: @scenario.id }

    Current.setting = Setting.load_from_scenario(@scenario)

    new_scenario = Api::Scenario.create(scenario: { scenario: scenario_attrs })
    Current.setting.api_session_id = new_scenario.id

    redirect_to play_path
  end

  # Public: Updates a saved scenario by assigning the `scenario_id` param. JSON only.
  #
  # PUT /scenarios/:id
  def update
    scenario_id = params.require(:scenario_id).to_i

    @saved_scenario = SavedScenario.find(params[:id])
    update = UpdateSavedScenario.call(@saved_scenario, scenario_id)

    if update.successful?
      render json: @saved_scenario
    else
      render json: { errors: update.errors }
    end
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

  # A "synonym" of `play`, which acts as an entrypoint for the scenario editor
  # used by the multi-year charts interface.
  #
  # MYC loads the ETM in an iframe, which prohibits redirects; redirecting
  # causes the loss of session data when the visitor has third-party cookies
  # disabled.
  #
  # This action loads the requested sceanrio with a minimal interface,
  # optionally sending the user straight to a specific input.
  #
  # GET /scenario/myc/:id
  def play_multi_year_charts
    Current.setting.reset!

    Current.setting.api_session_id = @scenario.id

    if params[:input] && (input = InputElement.find_by_key(params[:input]))
      Current.setting.last_etm_page = play_url(*input.url_components)
      @interface = Interface.new(*input.url_components)
    end

    @interface.variant = Interface::LiteVariant.new

    play
  end

  def compare
    @default_values = @scenarios.first.all_inputs
    @average_values = {}
    @average_values_using_defaults = {}
  end

  def merge
    inputs = params[:inputs_def]
    @inputs = YAML.load inputs
    end_year = params[:end_year].to_i
    end_year = 2050 unless end_year.between?(2010, 2050)
    @scenario = Api::Scenario.create(
      scenario: { scenario: {
        source: 'ETM',
        user_values: @inputs,
        area_code: params[:area_code] || 'nl',
        end_year: end_year
      }}
    )
  end

  def weighted_merge
  end

  def perform_weighted_merge
    scenarios = params.require(:merge_scenarios).permit!.to_h

    req_body = scenarios.map do |id, weight|
      { scenario_id: id, weight: weight }
    end

    result = HTTParty.post("#{APP_CONFIG[:api_url]}/api/v3/scenarios/merge", {
      body: { scenarios: req_body }.to_json,
      headers: {
        'Accept'       => 'application/json',
        'Content-Type' => 'application/json'
      }
    })

    body = JSON.parse(result.body)

    if (400..499).include?(result.code)
      @errors = body['errors']
      setup_comparison

      render :weighted_merge
    else
      redirect_to(scenario_url(body['id']))
    end
  end

  private

  # Finds the scenario from id
  def find_scenario
    @scenario = Api::Scenario.find(
      params[:id].to_i,
      params: { detailed: true }
    )

    unless @scenario.loadable?
      redirect_to root_path, notice: 'Sorry, this scenario cannot be loaded'
    end
  rescue ActiveResource::ResourceNotFound
    redirect_to root_path, notice: 'Scenario not found'
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

  def setup_comparison
    scenario_ids = params[:scenario_ids] || []
    @scenarios = scenario_ids.map{|id| Api::Scenario.find id, params: {detailed: true}}
    if @scenarios.empty?
      flash[:error] = "Please select one or more scenarios"
      redirect_to scenarios_path and return
    end
  end

  def redirect_compare
    if params[:merge]
      redirect_to(
        weighted_merge_scenarios_url(params.permit(scenario_ids: []))
      )

      return
    end

    if params[:combine]
      redirect_to(local_global_comparison_url)
      return
    end
  end

  def local_global_comparison_url
    ids = (params.permit(scenario_ids: [])[:scenario_ids] || [])
      .map(&:to_i).reject(&:zero?)

    if ids.empty?
      scenarios_url
    else
      local_global_scenarios_url(ids.join(','))
    end
  end

  # Internal: For requests originating in the "multi-year charts" application,
  # we must permit pages to be loaded in an iframe.
  def myc_content_security_policy
    url = APP_CONFIG[:multi_year_charts_url]

    return unless url

    response.set_header('X-Frame-Options', "allow-from #{url}")
    response.set_header('Content-Security-Policy', "frame-ancestors #{url}")
  end
end
