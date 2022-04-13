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

  # Act like a lambda
  include Service

  attr_reader :saved_scenario, :scenario_id, :settings

  def initialize(saved_scenario, scenario_id, settings = {})
    @saved_scenario, @scenario_id, @settings =
      saved_scenario, scenario_id, settings
  end

  def call
    return api_response if failure?

    saved_scenario.tap do |ss|
      ss.add_id_to_history(ss.scenario_id)
      ss.scenario_id = api_scenario.id
      unprotect and return failure unless saved_scenario.valid?
      ss.save
      saved_scenario.scenario = api_scenario
    end

    ServiceResult.success(saved_scenario)
  end

  private

  def unprotect
    SetApiScenarioCompatibility.dont_keep_compatible(api_scenario.id)
  end

  def failure
    ServiceResult.failure(saved_scenario.errors.map(&:full_message))
  end

  def api_scenario
    api_response.value
  end

  def api_response
    @api_response ||=
      CreateApiScenario.call(
        settings.merge(
          scenario_id: scenario_id,
        )
      )
  end

  def failure?
    api_response.failure?
  end
end
