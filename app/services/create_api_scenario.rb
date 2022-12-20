# frozen_string_literal: true

# Creates a new API scenario with the given attributes. Scenarios are marked as
# read-only unless otherwise configured using the given attributes.
CreateAPIScenario = lambda do |http_client, attributes = {}|
  attributes = attributes
    .slice(:area_code, :end_year, :scenario_id, :read_only)
    .reverse_merge(read_only: true, source: 'ETM')

  ServiceResult.success(Engine::Scenario.new(
    http_client.post('/api/v3/scenarios', { scenario: attributes }).body
  ))
rescue Faraday::UnprocessableEntityError => e
  return ServiceResult.failure_from_unprocessable_entity(e)
end
