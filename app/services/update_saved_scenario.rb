# frozen_string_literal: true

# Creates a new API scenario based on the given existing API `scenario_id`, and
# then adds it to the provided SavedScenario adding the old scenario to history.
# The new API scenario will be marked as read-only.
#
# saved_scenario  - The scenario to be updated
# scenario_id     - The ID of the scenario to be saved.
# settings        - Optional extra scenario data to be sent to ETEngine when
#                   creating the new API scenario.
#
# Returns a ServiceResult with the resulting SavedScenario.
class UpdateSavedScenario
  extend Dry::Initializer
  include Service

  param :http_client
  param :saved_scenario
  param :scenario_id
  param :settings, default: proc { {} }

  def call
    return api_response if failure?

    # "Manual scenario reverting" by the user, e.g. setting an earlier used scenario-id
    # as the current active scenario, is not allowed.
    if saved_scenario.scenario_id_history.include?(api_scenario.id)
      return ServiceResult.failure(
        "Scenario id #{api_scenario} is already present in this saved scenario's history.",
        saved_scenario
      )
    end

    saved_scenario.tap do |ss|
      ss.add_id_to_history(ss.scenario_id)
      ss.scenario_id = api_scenario.id

      unless ss.valid?
        unprotect
        return failure
      end

      protect

      ss.save
      saved_scenario.scenario = api_scenario
    end

    ServiceResult.success(saved_scenario)
  end

  private

  def protect
    SetAPIScenarioCompatibility.keep_compatible(http_client, api_scenario.id)
  end

  def unprotect
    SetAPIScenarioCompatibility.dont_keep_compatible(http_client, api_scenario.id)
  end

  def failure
    ServiceResult.failure(saved_scenario.errors.map(&:full_message))
  end

  def api_scenario
    api_response.value
  end

  def api_response
    @api_response ||= CreateAPIScenario.call(http_client, settings.merge(scenario_id:))
  end

  def failure?
    api_response.failure?
  end
end
