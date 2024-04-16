# frozen_string_literal: true

class FetchSavedScenarioVersionTags
  include Service

  def initialize(http_client, saved_scenario)
    @http_client = http_client
    @scenario_ids = saved_scenario.version_scenario_ids
  end

  def call
    ServiceResult.success(
      @http_client.get(
        '/api/v3/scenarios/versions',
        { scenarios: @scenario_ids }
      ).body
    )
  rescue Faraday::ResourceNotFound
    ServiceResult.failure('Scenario not found')
  rescue Faraday::Error => e
    Sentry.capture_exception(e)
    ServiceResult.failure('Failed to fetch scenario versions')
  end
end
