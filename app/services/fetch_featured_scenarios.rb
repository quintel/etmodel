# frozen_string_literal: true

FetchFeaturedScenarios = lambda do |http_client, version = nil|
  path = '/api/v1/featured_scenarios'
  path += "?version=#{version}" if version.present?

  response = http_client.get(path)
  featured_scenarios = response.body['featured_scenarios']

  ServiceResult.success(featured_scenarios)
rescue Faraday::ResourceNotFound
  ServiceResult.failure('Featured scenarios not found')
rescue Faraday::Error => e
  Sentry.capture_exception(e)
  ServiceResult.failure('Failed to fetch featured scenarios')
end
