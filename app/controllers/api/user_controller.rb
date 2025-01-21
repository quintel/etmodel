# frozen_string_literal: true

module API
  # Updates user information.
  class UserController < APIController
    before_action :verify_token!

    def update
    # Verify that the user being updated matches the user authorized by the token.
      if authorized_to_update_user?(user_params[:id])
        if current_user.update(user_params.except(:id))
          render json: current_user
        else
          render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        head :forbidden
      end
    end

    def destroy
      current_user.destroy
      head :ok
    end

    private

    def user_params
      user_params = params.require(:user).permit(:id, :name)

      # Explicitly check for blank values
      if user_params[:name].blank?
        raise ActionController::ParameterMissing, 'name'
      end

      user_params
    end

    def authorized_to_update_user?(user_id)
      current_user.id == user_id.to_i
    end
  end
end
