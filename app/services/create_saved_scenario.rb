# frozen_string_literal: true

# TODO update notes / explanation here to match new setup
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
  debugger
  response = http_client.post('/saved_scenarios'), { scenario_id: scenario_id }.merge(settings.except(:description, :title))

  return response if response.failure?

  idp_scenario = idp_res.value

  saved_scenario = SavedScenario.new(
    title: settings[:title],
    description: settings[:description],
    area_code: idp_scenario.area_code,
    end_year: idp_scenario.end_year,
    scenario_id: idp_scenario.id,
    private: idp_scenario.private?,
    user: current_user
  )

  unless saved_scenario.valid?
    http_client.set_idp_scenario_compatibility(idp_scenario.id, keep: false)

    # Reset id to original
    saved_scenario.scenario_id = scenario_id
    return ServiceResult.failure(saved_scenario.errors.map(&:full_message), saved_scenario)
  end

  http_client.set_idp_scenario_compatibility(idp_scenario.id, keep: true)
  http_client.create_idp_scenario_version_tag(idp_scenario.id, '')

  saved_scenario.save
  saved_scenario.scenario = idp_scenario

  ServiceResult.success(saved_scenario)
end
