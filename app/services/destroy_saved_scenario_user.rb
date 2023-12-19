# frozen_string_literal: true

# Destroys a user for a SavedScenario based on the given existing saved_scenario and
# then removes them from the current API scenario and all the old API scenarios in the history.
#
# saved_scenario        - The saved scenario to be updated
# saved_scenario_user   - The saved scenario user to be removed
#
#
# Returns a ServiceResult.
class DestroySavedScenarioUser
  extend Dry::Initializer
  include Service

  param :http_client
  param :saved_scenario
  param :saved_scenario_user

  def call
    if saved_scenario_user.destroy
      # TODO: and undo the destroy on fail!
      return api_response if failure?
      return historical_scenarios_result if historical_scenarios_result.failure?

      api_response
    else
      ServiceResult.failure(saved_scenario_user.errors.map(&:type))
    end
  end

  private

  def api_user_params
    @api_user_params ||= {
      user_id: saved_scenario_user.user_id,
      user_email: saved_scenario_user.user_email,
      role: User::ROLES[saved_scenario_user.role_id]
    }
  end

  # Destroy the user in ETEngine for the current scenario
  def api_response
    @api_response ||= DestroyAPIScenarioUser.call(
      http_client,
      saved_scenario.scenario_id,
      api_user_params
    )
  end

  def failure?
    api_response.failure?
  end

  # Update historical scenarios. If one fails, return the result immeadiately.
  def api_response_historical_scenarios
    saved_scenario.scenario_id_history.each do |scenario_id|
      result = DestroyAPIScenarioUser.call(
        http_client, scenario_id, api_user_params
      )
      return result if result.failure?
    end

    ServiceResult.success
  end

  # TODO: create user from all the ones that succeeded before the fail! << Here
  def historical_scenarios_result
    @historical_scenarios_result = api_response_historical_scenarios
  end
end
