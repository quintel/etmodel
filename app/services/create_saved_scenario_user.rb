# frozen_string_literal: true

# Creates a new user for a SavedScenario based on the given existing saved_scenario_id and
# then adds it to the current API scenario and all the old API scenarios in the history.
#
# saved_scenario  - The scenario to be updated
# invitee_name    - The name of the user inviting this user.
# settings        - Settings that contain info for the new user
#
#
# Returns a ServiceResult with the resulting SavedScenarioUser.
class CreateSavedScenarioUser
  extend Dry::Initializer
  include Service

  param :http_client
  param :saved_scenario
  param :invitee_name
  param :settings, default: proc { {} }

  def call
    return api_response_invite if invite_failure?
    return failure unless saved_scenario_user.valid?
    return historical_scenarios_result if historical_scenarios_result.failure?

    saved_scenario_user.save

    ServiceResult.success(saved_scenario_user)
  rescue ActiveRecord::RecordNotUnique
    ServiceResult.failure('duplicate')
  end

  private

  def saved_scenario_user
    @saved_scenario_user ||= SavedScenarioUser.new(
      succesful_user_params.merge(saved_scenario: saved_scenario)
    )
  end

  # This should never occur as the record is prevalidated by the engine
  def failure
    ServiceResult.failure(saved_scenario_user.errors.messages.keys)
  end

  def succesful_user_params
    raw = api_response_invite.value.first

    {
      user_id: raw['user_id'] ? raw['user_id'].to_i : nil,
      user_email: raw['user_email'],
      role_id: raw['role_id'].to_i
    }
  end

  def api_user_params
    @api_user_params ||= {
      user_id: settings[:user_id],
      user_email: settings[:user_email],
      role: User::ROLES[settings[:role_id].to_i]
    }
  end

  # Create the user in the engine and send an invite
  def api_response_invite
    @api_response_invite ||= CreateAPIScenarioUser.call(
      http_client,
      saved_scenario.scenario_id,
      api_user_params,
      {
        invite: true,
        user_name: invitee_name,
        id: saved_scenario.id,
        title: saved_scenario.title
      }
    )
  end

  def invite_failure?
    api_response_invite.failure?
  end

  # Update historical scenarios. If one fails, just move on to the next
  def api_response_historical_scenarios
    saved_scenario.scenario_id_history.each do |scenario_id|
      CreateAPIScenarioUser.call(
        http_client, scenario_id, api_user_params
      )
    end

    ServiceResult.success
  end

  def historical_scenarios_result
    @historical_scenarios_result = api_response_historical_scenarios
  end
end
