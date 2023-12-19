# frozen_string_literal: true

# Updates a role for a user for a SavedScenario based on the given existing saved_scenario and
# then updates them for the current API scenario and all the old API scenarios in the history.
#
# saved_scenario        - The saved scenario to be updated
# saved_scenario_user   - The saved scenario user to be updated
# role_id               - Settings that contain update info for the user
#
#
# Returns a ServiceResult.
class UpdateSavedScenarioUser
  extend Dry::Initializer
  include Service

  param :http_client
  param :saved_scenario
  param :saved_scenario_user
  param :role_id

  def call
    saved_scenario_user.role_id = role_id

    return failure unless saved_scenario_user.save
    return api_response if failure?
    return historical_scenarios_result if historical_scenarios_result.failure?

    ServiceResult.success(saved_scenario_user)
  end

  private

  def failure
    ServiceResult.failure(saved_scenario_user.errors.map(&:type))
  end

  def api_user_params
    @api_user_params ||= {
      user_id: saved_scenario_user.user_id,
      user_email: saved_scenario_user.user_email,
      role: role_id
    }
  end

  # Update the user in ETEngine for the current scenario
  def api_response
    @api_response ||= UpdateAPIScenarioUser.call(
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
      result = UpdateAPIScenarioUser.call(
        http_client, scenario_id, api_user_params
      )
      return result if result.failure?
    end

    ServiceResult.success
  end

  # TODO: downgrade user from all the ones that succeeded before the fail! << Here
  def historical_scenarios_result
    @historical_scenarios_result = api_response_historical_scenarios
  end
end
