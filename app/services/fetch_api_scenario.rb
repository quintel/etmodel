# frozen_string_literal: true

FetchAPIScenario = lambda do |http_client, id|
  ServiceResult.success(
    Engine::Scenario.new(http_client.get("/api/v3/scenarios/#{id}").body)
  )
rescue Faraday::ResourceNotFound
  return ServiceResult.failure('Scenario not found')
rescue Faraday::Error => e
  Sentry.capture_exception(e)
  return ServiceResult.failure('Failed to fetch scenario')
end
