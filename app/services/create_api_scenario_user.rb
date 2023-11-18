# frozen_string_literal: true

# Creates a new ScenarioUser for an ApiScenario
class CreateAPIScenarioUser
  include Service

  # Creates a ScenarioUser for multiple Scenarios.
  def self.call_with_ids(http_client, ids, scenario_user)
    ids.each { |id| call(http_client, id, scenario_user) }
  end

  def initialize(http_client, id, scenario_user)
    @http_client = http_client
    @id = id
    @scenario_user = scenario_user
  end

  def call
    ServiceResult.success(
      @http_client.post("/api/v3/scenarios/#{@id}/users", scenario_users: [@scenario_user]).body
    )
  rescue Faraday::ResourceNotFound
    ServiceResult.failure('Scenario not found')
  rescue Faraday::Error => e
    Sentry.capture_exception(e)
    ServiceResult.failure("Failed to create scenario user: #{e.message}")
  end
end

