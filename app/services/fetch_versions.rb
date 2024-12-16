# frozen_string_literal: true

# Fetches the full list of versions
#
# Returns a hash where each key is the input key and the value is an Input object.
FetchAPIScenarioInputs = lambda do |http_client, id|
  body = http_client.get("/api/v1/versions").body

  ServiceResult.success(
    puts body
  )
rescue Faraday::ResourceNotFound
  ServiceResult.failure('Versions not found')
rescue Faraday::Error => e
  Sentry.capture_exception(e)
  ServiceResult.failure('Failed to fetch versions')
end
