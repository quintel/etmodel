# frozen_string_literal: true

# Calls ETEngine to create a new scenario with input values interpolated from
# another scenario.
#
# scenario_id - The ID of the source scenario whose input values will be
#               interpolated for a new end year.
# year        - The end year of the new scenario.
#
# Returns a ServiceResult with either the parsed JSON response, or the errors
# returned by ETEngine.
InterpolateAPIScenario = lambda do |scenario_id, year|
  url = "#{APP_CONFIG[:api_url]}/api/v3/scenarios/#{scenario_id}/interpolate"
  response = HTTParty.post(url, body: { end_year: year })

  if response.ok?
    ServiceResult.success(response.to_h)
  else
    ServiceResult.failure(response['errors'])
  end
end
