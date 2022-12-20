# frozen_string_literal: true

# Sets the `keep_compatible` setting on an API scenario.
#
# When `keep_compatible` is true, ETEngine will automatically migrate the scenario to account for
# changes to the model. This allows the scenario to remain relevant in the future. Throwaway
# scenarios can have their `keep_compatible` setting set to false (which is the default).
#
# http_client     - The client used to communiate with ETEngine.
# scenario_id     - The ID of the ETEngine scenario to be unprotected.
# keep_compatible - A boolean indicating if the API scenario needs to be kept compatible.
#
# Returns a ServiceResult.
module SetAPIScenarioCompatibility
  module_function

  def call(http_client, scenario_id, keep_compatible)
    http_client.put(
      "/api/v3/scenarios/#{scenario_id}",
      scenario: { keep_compatible: !!keep_compatible }
    )

    ServiceResult.success
  rescue Faraday::UnprocessableEntityError => e
    ServiceResult.failure_from_unprocessable_entity(e)
  rescue Faraday::ClientError => e
    Sentry.capture_exception(e)
    ServiceResult.failure
  end

  def keep_compatible(http_client, scenario_id)
    call(http_client, scenario_id, true)
  end

  def dont_keep_compatible(http_client, scenario_id)
    call(http_client, scenario_id, false)
  end
end
