# frozen_string_literal: true

# Creates a scenario suitable for use as a testing ground (in the ETMoses
# application). Logged-in users will have their scenario saved, while guests
# will simply have a new scenario created based on the given scenario ID.
#
# scenario_id - The ID of the scenario to be saved.
# user        - Optional user to which the saved scenario will belong.
#
# Returns a ServiceResult.
CreateTestingGroundScenario = lambda do |scenario_id, user|
  settings = { title: "#{scenario_id} scaled", scenario_id: scenario_id }

  return CreateAPIScenario.call(settings) if user.nil?

  saved_res = CreateSavedScenario.call(scenario_id, user, settings)

  return saved_res if saved_res.failure?

  ServiceResult.success(saved_res.value.scenario)
end
