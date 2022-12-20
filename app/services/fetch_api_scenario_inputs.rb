# frozen_string_literal: true

# Fetches the full list of inputs for a scenario, including their min, max, start, values.
#
# Returns a hash where each key is the input key and the value is an Input object.
FetchAPIScenarioInputs = lambda do |http_client, id|
  body = http_client.get("/api/v3/scenarios/#{id}/inputs").body

  ServiceResult.success(
    body.each_with_object({}) do |(key, value), data|
      data[key] = Engine::Input.new(value.merge('key' => key))
    end
  )
rescue Faraday::ResourceNotFound
  ServiceResult.failure('Scenario not found')
rescue Faraday::Error => e
  Sentry.capture_exception(e)
  ServiceResult.failure('Failed to fetch inputs')
end
