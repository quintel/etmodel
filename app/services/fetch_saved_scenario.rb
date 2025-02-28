# frozen_string_literal: true

FetchSavedScenario = lambda do |http_client, scenario_id|
  path = "/api/v1/saved_scenarios/#{scenario_id}"
  response = http_client.get(path)

  saved_scenario = SavedScenario.from_params(response.body)

  ServiceResult.success(saved_scenario)
rescue Faraday::ResourceNotFound
  ServiceResult.failure('Saved scenario not found')
rescue Faraday::Error => e
  Sentry.capture_exception(e)
  ServiceResult.failure('Failed to fetch saved scenario')
rescue JSON::ParserError => e
  Sentry.capture_exception(e)
  ServiceResult.failure('Invalid response format')
end
