class SavedScenarioVersionsController < ApplicationController
  before_action :load_and_authorize_saved_scenario
  before_action :load_and_authorize_saved_scenario_version, only: %i[load revert duplicate]
  before_action :assign_scenario, only: :load

  helper_method :owned_saved_scenario?

  # Shows a form for creating a new saved scenario version.
  #
  # GET /saved_scenarios/:saved_scenario_id/version/new
  def new
    @saved_scenario_version = @saved_scenario.saved_scenario_versions.new(
      saved_scenario_id: permitted_params[:saved_scenario_id],
      scenario_id: permitted_params[:scenario_id]
    )

    render 'new', layout: false
  end

  def create
    @saved_scenario_version = @saved_scenario.saved_scenario_versions.new(
      permitted_params[:saved_scenario_version].merge(user: current_user)
    )

    begin
      @saved_scenario_version.save!
    rescue ActiveRecord::RecordInvalid
      error_message = t('scenario.versions.errors.create_message') if @saved_scenario_version.errors.first&.attribute == :message
    rescue ActiveRecord::RecordNotUnique
      error_message = 'saved_scenario_version_exists'
    end

    if @saved_scenario_version.persisted?
      @saved_scenario.set_version_as_current(@saved_scenario_version.attributes)

      render json: @saved_scenario_version, status: :ok
    else
      error = error_message.presence || "#{t('scenario.versions.errors.create')} #{t('scenario.versions.errors.general')}"

      render json: { error: error }, status: :unprocessable_entity
    end
  end

  def load
    scenario_attrs = { scenario_id: @saved_scenario_version.scenario_id }

    Current.setting =
      Setting.load_from_scenario(
        @scenario,
        active_saved_scenario: {
          id: nil,
          title: @saved_scenario.localized_title(I18n.locale)
        }
      )

    new_scenario = CreateAPIScenario.call(engine_client, scenario_attrs).or do
      flash[:alert] = t('scenario.cannot_load')
      return redirect_to(saved_scenario_path(params[:id]))
    end

    Current.setting.api_session_id = new_scenario.id
    redirect_to play_path
  end

  def revert
    @saved_scenario.set_version_as_current(@saved_scenario_version, revert: true)

    redirect_to @saved_scenario
  end

  private

  def permitted_params
    params.permit(:saved_scenario_id, :scenario_id, :id, saved_scenario_version: %i[id scenario_id message])
  end

  def load_and_authorize_saved_scenario
    render_not_found('saved scenario') and return false unless current_user.present?

    @saved_scenario = current_user.saved_scenarios.find_by(id: permitted_params[:saved_scenario_id])

    render_not_found('saved scenario') and return false unless @saved_scenario && owned_saved_scenario?
  end

  def load_and_authorize_saved_scenario_version
    @saved_scenario_version = @saved_scenario.saved_scenario_versions.find(permitted_params[:id])

    render_not_found('saved scenario version') and return false unless @saved_scenario_version
  end

  def owned_saved_scenario?
    @saved_scenario.collaborator?(current_user) || @saved_scenario.owner?(current_user)
  end

  def assign_scenario
    @scenario = @saved_scenario.scenario(engine_client, @saved_scenario_version.scenario_id)

    unless @scenario&.loadable?
      redirect_to @saved_scenario, notice: 'Sorry, this scenario cannot be loaded'
    end
  rescue ActiveResource::ResourceNotFound
    redirect_to @saved_scenario, notice: 'Scenario not found'
  end
end
