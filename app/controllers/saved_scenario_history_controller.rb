# frozen_string_literal: true

# Controller that fetches and updates the scenario versions underlying a saved scenario
class SavedScenarioHistoryController < ApplicationController
  before_action :assign_saved_scenario

  before_action only: %i[index] do
    authorize!(:read, @saved_scenario)
  end

  before_action only: %i[update] do
    authorize!(:update, @saved_scenario)
  end

  # GET /saved_scenarios/:id/history
  def index
    version_tags_result = FetchSavedScenarioVersionTags.call(engine_client, @saved_scenario)

    if version_tags_result.successful?
      @history = SavedScenarioHistoryPresenter.present(@saved_scenario, version_tags_result.value)

      respond_to do |format|
        format.js
        format.json { render @history }
      end
    else
      render version_tags_result.error
    end
  end

  # PUT /saved_scenarios/:id/history/:scenario_id
  def update
    # TODO: scenario-id is known -> make a service!
  end

  # GET /saved_scenarios/:id/history/:scenario_id/edit
  def edit
    # TODO: add route and js form
  end

  private

  def assign_saved_scenario
    @saved_scenario = SavedScenario.find(params[:saved_scenario_id])
  rescue ActiveRecord::RecordNotFound
    # TODO: json oly so render empty json? Or one that says: errors: not found??
    render_not_found
  end
end
