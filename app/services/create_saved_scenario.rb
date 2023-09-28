# frozen_string_literal: true

# Creates a new API scenario based on the given existing API `scenario_id`, and
# then creates a new SavedScenario. The new API scenario will be marked as
# protected.
#
# http_client - The client used to communiate with ETEngine.
# scenario_id - The ID of the scenario to be saved.
# user        - User to which the saved scenario will belong.
# settings    - Optional extra scenario data to be sent to ETEngine when
#               creating the new API scenario. Also contains details for the
#               creation of the saved scenario, like the title and description
#
# Returns a ServiceResult with the resulting SavedScenario.
CreateSavedScenario = lambda do |http_client, scenario_id, user, settings = {}|
  api_res = CreateAPIScenario.call(
    http_client, settings.except(:description, :title).merge(scenario_id:)
  )

  return api_res if api_res.failure?

  api_scenario = api_res.value

  saved_scenario = SavedScenario.new(
    title: settings[:title],
    description: settings[:description],
    area_code: api_scenario.area_code,
    end_year: api_scenario.end_year,
    scenario_id: api_scenario.id,
    private: api_scenario.private?,
    user:
  )

  unless saved_scenario.valid?
    SetAPIScenarioCompatibility.dont_keep_compatible(http_client, api_scenario.id)

    # Set the scenario ID back to the original, rather than the cloned scenario created by
    # CreateAPIScenario.
    saved_scenario.scenario_id = scenario_id
    return ServiceResult.failure(saved_scenario.errors.map(&:full_message), saved_scenario)
  end

  SetAPIScenarioCompatibility.keep_compatible(http_client, api_scenario.id)

  saved_scenario.save
  saved_scenario.scenario = api_scenario

  ServiceResult.success(saved_scenario)
end
