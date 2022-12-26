# frozen_string_literal: true

# Calls ETEngine to create a new scenario with input values interpolated from
# another scenario.
#
# http_client     - The client used to communiate with ETEngine.
# scenario_id     - The ID of the source scenario whose input values will be interpolated for a new
#                   end year.
# end_year        - The end year of the new scenario.
# keep_compatible - Flag the scenario to be migrated with automatic updated when the model changes.
#
# Returns a ServiceResult with either the parsed JSON response, or the errors
# returned by ETEngine.
InterpolateAPIScenario = lambda do |http_client, scenario_id, end_year, keep_compatible: false|
  ServiceResult.success(
    http_client.post(
      "/api/v3/scenarios/#{scenario_id}/interpolate",
      end_year:, keep_compatible:
    ).body
  )
rescue Faraday::UnprocessableEntityError => e
  ServiceResult.failure_from_unprocessable_entity(e)
rescue Faraday::Error => e
  Sentry.capture_exception(e)
  ServiceResult.failure('Failed to interpolate scenario')
end
