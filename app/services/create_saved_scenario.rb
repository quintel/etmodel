# frozen_string_literal: true

# Creates a new API scenario based on the given existing API `scenario_id`, and
# then creates a new SavedScenario. The new API scenario will be marked as
# protected.
#
# scenario_id - The ID of the scenario to be saved.
# user        - User to which the saved scenario will belong.
# settings    - Optional extra scenario data to be sent to ETEngine when
#               creating the new API scenario. Also contains details for the
#               creation of the saved scenario, like the title and description
#
# Returns a ServiceResult with the resulting SavedScenario.
CreateSavedScenario = lambda do |scenario_id, user, settings = {}|
  api_res = CreateAPIScenario.call(
    settings.except(:description, :title).merge(scenario_id: scenario_id)
  )

  return api_res if api_res.failure?

  api_scenario = api_res.value

  saved_scenario = SavedScenario.new(
    title: settings[:title],
    description: settings[:description],
    user: user,
    scenario_id: api_scenario.id
  )

  unless saved_scenario.valid?
    UnprotectAPIScenario.call(api_scenario.id)
    return ServiceResult.failure(saved_scenario.errors.full_messages)
  end

  saved_scenario.save
  saved_scenario.scenario = api_scenario

  ServiceResult.success(saved_scenario)
end
