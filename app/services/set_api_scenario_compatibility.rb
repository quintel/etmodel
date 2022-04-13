# frozen_string_literal: true

# Sets the `keep_compatible` setting on an API scenario.
#
# When `keep_compatible` is true, ETEngine will automatically migrate the scenario to account for
# changes to the model. This allows the scenario to remain relevant in the future. Throwaway
# scenarios can have their `keep_compatible` setting set to false (which is the default).
#
# scenario_id     - The ID of the ETEngine scenario to be unprotected.
# keep_compatible - A boolean indicating if the API scenario needs to be kept compatible.
#
# Returns a ServiceResult.
module SetApiScenarioCompatibility
  module_function

  def call(scenario_id, keep_compatible)
    response = HTTParty.put(
      "#{Settings.api_url}/api/v3/scenarios/#{scenario_id}",
      body: { scenario: { keep_compatible: !!keep_compatible } }
    )

    if response.ok?
      ServiceResult.success
    else
      ServiceResult.failure(response['errors'])
    end
  end

  def keep_compatible(scenario_id)
    call(scenario_id, true)
  end

  def dont_keep_compatible(scenario_id)
    call(scenario_id, false)
  end
end
