# frozen_string_literal: true

# Calls ETEngine to create a new scenario with input values interpolated from
# another scenario.
#
# scenario_id - The ID of the source scenario whose input values will be
#               interpolated for a new end year.
# year        - The end year of the new scenario.
# protect     - Mark the scenario as protected so that it will be updated to
#               reflect future model changes?
#
# Returns a ServiceResult with either the parsed JSON response, or the errors
# returned by ETEngine.
InterpolateAPIScenario = lambda do |scenario_id, year, protect: false|
  url = "#{Settings.api_url}/api/v3/scenarios/#{scenario_id}/interpolate"

  # Send as JSON so that "protected" is true/false not "true"/"false".
  response = HTTParty.post(
    url,
    body: { end_year: year, protected: protect }.to_json,
    headers: {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  )

  if response.ok?
    ServiceResult.success(response.to_h)
  else
    ServiceResult.failure(response['errors'])
  end
end
