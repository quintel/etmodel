# frozen_string_literal: true

# Removes a MultiYearChart from the database, along with all related scenarios,
# and instructs ETEngine that the scenarios no longer need to be protected.
#
# scenario_id - The ID of the ETEngine scenario to be unprotected.
#
# Returns a ServiceResult.
UnprotectAPIScenario = lambda do |scenario_id|
  response = HTTParty.put(
    "#{Settings.api_url}/api/v3/scenarios/#{scenario_id}",
    body: { scenario: { protected: false } }
  )

  if response.ok?
    ServiceResult.success
  else
    ServiceResult.failure(response['errors'])
  end
end
