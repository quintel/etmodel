class SavedScenarioVersionsController < ApplicationController
  before_action :load_and_authorize_saved_scenario
  load_resource only: %i[set_as_current]

  helper_method :owned_saved_scenario?

  def index
    # Render scenario version history table
  end

  # Shows a form for creating a new saved scenario version.
  #
  # GET /saved_scenarios/:saved_scenario_id/history/new
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

    if @saved_scenario_version.save
      @saved_scenario.set_version_as_current(@saved_scenario_version.attributes)

      render :ok, json: []
    else
      render :unprocessable_entity, json: []
    end
  end

  # Set a given SavedScenarioVersion as the current version for the given SavedScenario.
  # This discards all SavedScenarioVersions that lie in the future of the given SavedScenarioVersion.
  def revert_previous_version
    @saved_scenario.revert_previous_version_to(@saved_scenario_version)
  end

  private

  def permitted_params
    params.permit(:saved_scenario_id, :scenario_id, saved_scenario_version: %i[id scenario_id message :discarded])
  end

  def load_and_authorize_saved_scenario
    render_not_found('saved scenario') and return false unless current_user.present?

    @saved_scenario = current_user.saved_scenarios.find_by(id: permitted_params[:saved_scenario_id])

    render_not_found('saved scenario') and return false unless @saved_scenario && owned_saved_scenario?
  end

  def owned_saved_scenario?
    @saved_scenario.collaborator?(current_user) || @saved_scenario.owner?(current_user)
  end
end
