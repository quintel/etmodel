# frozen_string_literal: true

module API
  # Updates user information.
  class UserController < APIController
    before_action :verify_token!

    def update
      # Verify that the user being updated matches the user authorized by the token.
      return head(:forbidden) if current_user.id != params.require(:id).to_i

      if current_user.update(name: params.require(:name))
        render json: current_user
      else
        render json: current_user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      # Remove the SavedScenarios associated with this user where its the only user left
      current_user.saved_scenarios.each { |ss| ss.destroy if ss.users.count == 1 }

      # Then destroy the user itself
      current_user.destroy

      head :ok
    end
  end
end
