module API
  # Allows owners of a SavedScenario to manage the roles for users on a given scenario
  class SavedScenarioUsersController < APIController
    #before_action :verify_token!
    before_action :find_scenario

    def show
      render json: current_user.saved_scenarios.find(params.require(:id)).users.map { |u| u.slice(:id, :name) }
    end

    def create
      scenario_params[:users].each do |user_params|
        @scenario.users << build_saved_scenario_user(user_params)
      end

      if @scenario.save
        render json: users_return_values, status: :created
      else
        render json: scenario.errors, status: :unprocessable_entity
      end
    end

    def update
      scenario_users_updated = true
      scenario_user_error = nil
      http_error_status = :unprocessable_entity

      scenario_params[:users].each do |user_params|
        su = @scenario.users.find(
          user_id: user_params.try(:[], :user_id)
        )

        if su.blank?
          scenario_users_updated = false
          http_error_status = :not_found

          break
        end

        unless (scenario_users_updated = su.update(role_id: User::ROLES.key(user_params.try(:[], :role))))
          scenario_user_error = su.errors

          break
        end
      end

      if scenario_users_updated
        render json: users_return_values, status: :ok
      else
        render json: scenario_user_error, status: http_error_status
      end
    end

    def destroy
      @scenario.users.where(
        user_id: params.permit(user_ids: [])[:user_ids]
      ).destroy_all

      head :ok
    end

    private

    def saved_scenario_params
      params.permit(:id, users: [])
    end

    def find_saved_scenario
      @saved_scenario = current_user.saved_scenarios.find(saved_scenario_params[:id])
    end

    def users_return_values
      @scenario.users.map do |u|
        { id: u.user_id, email: u.user_email, role: User::ROLES[u.role_id] }
      end
    end

    def build_saved_scenario_user(user_params)
      user = User.find_by(email: user_params.try(:[], :email))

      SavedScenarioUser.new(
        user_id: user_params.try(:[], :id),
        saved_scenario_id: scenario_params[:id],
        role_id: User::ROLES.key(user_params.try(:[], :role)),
        user_email: user.present? ? nil : user_params.try(:[], :email)
      )
    end
  end

end
