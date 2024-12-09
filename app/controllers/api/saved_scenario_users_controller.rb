# frozen_string_literal: true

module API
  # Allows users to manage users for saved scenarios.
  class SavedScenarioUsersController < APIController

  # TODO: port me!!


  #   before_action :verify_token!

  #   # Only scenario owners, having the delete authority, may manage scenario users.
  #   # The scenario:delete scope is something only owners have.
  #   before_action { verify_scopes!(%w[scenarios:delete]) }

  #   before_action :find_and_authorize_saved_scenario

  #   def index
  #     render json: @saved_scenario.saved_scenario_users
  #   end

  #   # TODO: Bundle and send all at once to the engine API!
  #   def create
  #     handle_saved_scenario_users do |user_params|
  #       CreateSavedScenarioUser.call(
  #         engine_client, @saved_scenario, current_user.name, user_params
  #       )
  #     end

  #     if errors.empty?
  #       @saved_scenario.reload
  #       render json: @succesfull_users, status: :created
  #     else
  #       render json: { success: @succesfull_users, errors: errors }, status: :unprocessable_entity
  #     end
  #   end

  #   # TODO: Bundle and send all at once to the engine API!
  #   def update
  #     handle_saved_scenario_users do |user_params|
  #       UpdateSavedScenarioUser.call(
  #         engine_client,
  #         @saved_scenario,
  #         find_saved_scenario_user(user_params),
  #         user_params[:role_id]&.to_i
  #       )
  #     end

  #     if errors.empty?
  #       @saved_scenario.reload
  #       render json: @succesfull_users, status: :ok
  #     else
  #       render json: { success: @succesfull_users, errors: errors }, status: :unprocessable_entity
  #     end
  #   end

  #   # TODO: Bundle and send all at once to the engine API!
  #   def destroy
  #     handle_saved_scenario_users do |user_params|
  #       DestroySavedScenarioUser.call(
  #         engine_client,
  #         @saved_scenario,
  #         find_saved_scenario_user(user_params)
  #       )
  #     end

  #     if errors.empty?
  #       render json: @succesfull_users, status: :ok
  #     else
  #       render json: { success: @succesfull_users, errors: errors }, status: :unprocessable_entity
  #     end
  #   end

  #   private

  #   def permitted_params
  #     params.permit(:saved_scenario_id, saved_scenario_users: [%i[id role user_id user_email]])
  #   end

  #   def find_and_authorize_saved_scenario
  #     @saved_scenario = \
  #       if current_user.admin?
  #         SavedScenario.find(permitted_params[:saved_scenario_id])
  #       else
  #         current_user.saved_scenarios.find(permitted_params[:saved_scenario_id])
  #       end
  #   end

  #   # One day we make this pretty
  #   def handle_saved_scenario_users
  #     @succesfull_users = permitted_params[:saved_scenario_users].filter_map do |user_params|
  #       user_params = scenario_user_params(user_params)
  #       result = yield user_params

  #       if result.successful?
  #         result.value
  #       else
  #         add_error(user_params[:user_email], result.errors)
  #         nil
  #       end
  #     end
  #   end

  #   def scenario_user_params(user_params)
  #     user = User.find(user_params[:user_id]) if user_params[:user_id].present?

  #     {
  #       id: user_params[:id]&.to_i,
  #       role_id: User::ROLES.key(user_params.try(:[], :role).try(:to_sym)),
  #       user_id: user&.id,
  #       user_email: user&.email || user_params.try(:[], :user_email)
  #     }
  #   end

  #   def find_saved_scenario_user(user_params)
  #     if user_params[:id]
  #       @saved_scenario.saved_scenario_users.find(user_params[:id])
  #     elsif user_params[:user_id]
  #       @saved_scenario.saved_scenario_users.find_by!(user_id: user_params[:user_id])
  #     else
  #       @saved_scenario.saved_scenario_users.find_by!(user_email: user_params[:user_email])
  #     end
  #   end

  #   def errors
  #     @errors ||= {}
  #   end

  #   def add_error(user_label, message)
  #     errors[user_label] = message
  #   end
  end
end
