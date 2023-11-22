# frozen_string_literal: true

# Updates the role of a ScenarioUser for an ApiScenario
class DestroyAPIScenarioUser
  include Service

  def initialize(http_client, scenario_id, scenario_user)
    @http_client = http_client
    @scenario_id = scenario_id
    @scenario_user = scenario_user
  end

  def call
    ServiceResult.success(
      @http_client.delete(
        "/api/v3/scenarios/#{@scenario_id}/users", scenario_users: [@scenario_user]
      ).body
    )
  rescue Faraday::ResourceNotFound
    ServiceResult.failure('Scenario not found')
  rescue Faraday::Error => e
    Sentry.capture_exception(e)
    ServiceResult.failure("Failed to destroy scenario user: #{e.message}")
  end
end

