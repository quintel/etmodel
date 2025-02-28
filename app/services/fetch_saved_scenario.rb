# frozen_string_literal: true

FetchSavedScenario = lambda do |http_client, scenario_id|
  path = "/api/v1/saved_scenarios/#{scenario_id}"
  response = http_client.get(path)
  response = response.body
  saved_scenario_users = response.delete("saved_scenario_users")
  private_flag = response.delete("private")

  saved_scenario = SavedScenario.from_params(response)

  ServiceResult.success({ saved_scenario: saved_scenario, saved_scenario_users: saved_scenario_users, private_flag: private_flag })
rescue Faraday::ResourceNotFound
  ServiceResult.failure('Saved scenario not found')
rescue Faraday::Error => e
  Sentry.capture_exception(e)
  ServiceResult.failure('Failed to fetch saved scenario')
rescue JSON::ParserError => e
  Sentry.capture_exception(e)
  ServiceResult.failure('Invalid response format')
end
