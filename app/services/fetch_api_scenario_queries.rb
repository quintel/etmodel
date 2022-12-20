# frozen_string_literal: true

# Fetches the named queries for the scenario.
#
# Returns
FetchAPIScenarioQueries = lambda do |http_client, id, queries|
  body = http_client.put("/api/v3/scenarios/#{id}", gqueries: Array(queries)).body
  ServiceResult.success(
    body['gqueries'].each_with_object({}) do |(key, value), data|
      data[key] = Engine::Query.new(value.merge(key: key))
    end
  )
rescue Faraday::ResourceNotFound
  ServiceResult.failure('Scenario not found')
rescue Faraday::UnprocessableEntityError => e
  # Capture the error so that we can be notified of outdated queries in the template.
  Sentry.capture_exception(e)
  ServiceResult.failure_from_unprocessable_entity(e)
rescue Faraday::Error => e
  Sentry.capture_exception(e)
  ServiceResult.failure('Failed to fetch queries')
end
