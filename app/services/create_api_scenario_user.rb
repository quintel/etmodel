# frozen_string_literal: true

# Creates a new ScenarioUser for an ApiScenario
class CreateAPIScenarioUser
  include Service

  def initialize(http_client, id, scenario_user, invitation_args = nil)
    @http_client = http_client
    @id = id
    @scenario_user = scenario_user
    @invitation_args = invitation_args
  end

  def call
    ServiceResult.success(
      @http_client.post(
        "/api/v3/scenarios/#{@id}/users",
        { scenario_users: [@scenario_user], invitation_args:  @invitation_args, origin: 'etmodel' }
      ).body
    )
  rescue Faraday::ResourceNotFound
    ServiceResult.failure('Scenario not found')
  rescue Faraday::Error => e
    Sentry.capture_exception(e)
    ServiceResult.failure("Failed to create scenario user: #{e.message}")
  end
end

