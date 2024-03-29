# frozen_string_literal: true

# Copies the roles of the preset API scenario to an API scenario.
#
#
# http_client     - The client used to communiate with ETEngine.
# scenario_id     - The ID of the ETEngine scenario to be setting the roles for
#
# Returns a ServiceResult.
module SetAPIScenarioRoles
  module_function

  def call(http_client, scenario_id)
    http_client.put(
      "/api/v3/scenarios/#{scenario_id}",
      scenario: { set_preset_roles: true }
    )

    ServiceResult.success
  rescue Faraday::UnprocessableEntityError => e
    ServiceResult.failure_from_unprocessable_entity(e)
  rescue Faraday::ClientError => e
    Sentry.capture_exception(e)
    ServiceResult.failure
  end

  def to_preset(http_client, scenario_id)
    call(http_client, scenario_id)
  end
end
