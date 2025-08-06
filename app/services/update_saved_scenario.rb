# frozen_string_literal: true

# Creates a new API scenario based on the given existing API `scenario_id`, and
# then adds the current scenario to the provided SavedScenario, and adding the old
# scenario to history.
# The new API scenario can be set as current one to continue working.
#
# saved_scenario  - The scenario to be updated
# scenario_id     - The ID of the scenario to be saved.
# settings        - Optional extra scenario data to be sent to ETEngine when
#                   creating the new API scenario.
#
# Returns a ServiceResult with the new API scenario.
class UpdateSavedScenario
  extend Dry::Initializer
  include Service

  param :http_client
  param :saved_scenario_id
  param :scenario_id

  def call
    response = http_client.put("api/v1/saved_scenarios/#{saved_scenario_id}") do |req|
      req.headers ||= {}
      req.headers['Content-Type'] = 'application/json'
      req.body = { scenario_id: scenario_id }.to_json
    end

    ServiceResult.success(response.body)
  rescue Faraday::UnprocessableEntityError => e
    ServiceResult.failure_from_unprocessable_entity(e)
  end
end
