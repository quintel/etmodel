# frozen_string_literal: true

# Controller that fetches and updates the scenario versions underlying a saved scenario
class SavedScenarioHistoryController < ApplicationController
  before_action :assign_saved_scenario

  before_action only: %i[index update] do
    authorize!(:update, @saved_scenario)
  end

  helper_method :editable_saved_scenario?

  # GET /saved_scenarios/:id/history
  def index
    version_tags_result = FetchSavedScenarioVersionTags.call(engine_client, @saved_scenario)

    if version_tags_result.successful?
      @history = SavedScenarioHistoryPresenter.present(@saved_scenario, version_tags_result.value)

      respond_to do |format|
        format.html { render 'index', layout: 'saved_scenario' }
        format.js
        format.json { render json: @history }
      end
    else
      # TODO: respond_to -> pass error to js
      # @error = ...
      @history = {}
      respond_to do |format|
        format.json { render version_tags_result.errors }
        format.js
      end
    end
  end

  # PUT /saved_scenarios/:id/history/:scenario_id
  def update
    result = UpdateAPIScenarioVersionTag.call(
      engine_client,
      params[:scenario_id],
      update_params[:description]
    )

    if result.successful?
      respond_to do |format|
        format.json { render json: result.value }
      end
    else
      respond_to do |format|
        format.json { render json: result.errors }
      end
    end
  end

  private

  def update_params
    params.permit(:description)
  end

  def assign_saved_scenario
    @saved_scenario = SavedScenario.find(params[:saved_scenario_id])
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end

  # This determines whether the SavedScenario is editable by the current_user
  def editable_saved_scenario?(saved_scenario = nil)
    saved_scenario ||= @saved_scenario

    saved_scenario.collaborator?(current_user) ||
      saved_scenario.owner?(current_user) ||
      current_user&.admin?
  end
end
