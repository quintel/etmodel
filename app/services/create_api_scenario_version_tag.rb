# frozen_string_literal: true

# Creates a ScenarioVersionTag for an ApiScenario and the current user
class CreateAPIScenarioVersionTag
  include Service

  def initialize(http_client, scenario_id, description)
    @http_client = http_client
    @scenario_id = scenario_id
    @description = description
  end

  def call
    @http_client.post(
      "/api/v3/scenarios/#{@scenario_id}/version", description: @description
    )

    ServiceResult.success
  rescue Faraday::ResourceNotFound
    ServiceResult.failure('Scenario tag not found')
  rescue Faraday::UnprocessableEntityError => e
    ServiceResult.failure_from_unprocessable_entity(e)
  rescue Faraday::Error => e
    Sentry.capture_exception(e)
    ServiceResult.failure("Failed to update scenario version: #{e.message}")
  end
end
