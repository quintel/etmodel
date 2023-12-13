# frozen_string_literal: true

module API
  # Allows users to manage users for saved scenarios.
  class SavedScenarioUsersController < APIController
    before_action :verify_token!

    # Only scenario owners, having the delete authority, may manage scenario users.
    # The scenario:delete scope is something only owners have.
    before_action { verify_scopes!(%w[scenarios:delete]) }

    before_action :find_and_authorize_saved_scenario

    def index
      render json: users_return_values
    end

    def create
      permitted_params[:saved_scenario_users].each do |user_params|
        saved_scenario_user = new_saved_scenario_user_from(user_params)

        begin
          saved_scenario_user.save!
        rescue ActiveRecord::RecordInvalid
          render json: user_params.merge({ error: "#{saved_scenario_user.errors.first&.attribute} is invalid." }),
            status: :unprocessable_entity and return
        rescue ActiveRecord::RecordNotUnique
          render json: user_params.merge({ error: 'A user with this ID or email already exists for this saved scenario' }),
            status: :unprocessable_entity and return
        end

        if saved_scenario_user.persisted?
          synchronize_api_scenario_user('create', saved_scenario_user)
        end
      end

      if @saved_scenario.save
        render json: users_return_values, status: :created
      else
        render json: @saved_scenario.errors, status: :unprocessable_entity
      end
    end

    def update
      return unless validate_saved_scenario_user_params(['role', %w[id user_id user_email]])

      http_error_status, saved_scenario_user_error = nil, nil

      permitted_params[:saved_scenario_users].each do |user_params|
        # Find the user
        if user_params[:id].present?
          saved_scenario_user = @saved_scenario.saved_scenario_users.find(user_params[:id])
        elsif user_params[:user_id].present?
          saved_scenario_user = @saved_scenario.saved_scenario_users.find_by(user_id: user_params[:user_id])
        end

        if saved_scenario_user.blank?
          saved_scenario_user_error = user_params.merge({ error: 'Saved scenario user not found' })
          http_error_status = :not_found

          break
        end

        # Attempt to update the user
        unless saved_scenario_user.update(role_id: User::ROLES.key(user_params[:role].to_sym))
          saved_scenario_user_error = saved_scenario_user.errors
          http_error_status = :unprocessable_entity

          break
        end

        synchronize_api_scenario_user('update', saved_scenario_user)
      end

      if saved_scenario_user_error
        render json: saved_scenario_user_error, status: http_error_status
      else
        render json: users_return_values, status: :ok
      end
    end

    def destroy
      return unless validate_saved_scenario_user_params([%w[id user_id user_email]])

      # Find scenario_users by id, user_id or user_email,
      saved_scenario_users = @saved_scenario.saved_scenario_users.where(
        'id in (?) OR user_id IN (?) OR user_email IN (?)',
        permitted_params[:saved_scenario_users].pluck('id'),
        permitted_params[:saved_scenario_users].pluck('user_id'),
        permitted_params[:saved_scenario_users].pluck('user_email')
      )

      saved_scenario_users.each do |saved_scenario_user|
        synchronize_api_scenario_user('destroy', saved_scenario_user)

        saved_scenario_user.destroy
      end

      head :ok
    end

    private

    def permitted_params
      params.permit(:saved_scenario_id, saved_scenario_users: [%i[id role user_id user_email]])
    end

    def find_and_authorize_saved_scenario
      if current_user.blank?
        render json: [], status: :not_found

        return false
      end

      @saved_scenario = \
        if current_user.admin?
          SavedScenario.find(permitted_params[:saved_scenario_id])
        else
          current_user.saved_scenarios.find(permitted_params[:saved_scenario_id])
        end

      if @saved_scenario.blank? || (@saved_scenario.present? && !@saved_scenario.owner?(current_user) && !current_user.admin?)
        render json: [], status: :not_found

        return false
      end
    end

    def validate_saved_scenario_user_params(attributes)
      if permitted_params[:saved_scenario_users].blank?
        render json: { error: 'No users given to perform action on.' }, status: :unprocessable_entity

        return false
      end

      # Check if all scenario_users have the requested attributes
      permitted_params[:saved_scenario_users].each do |user_params|
        attributes.each do |attribute|
          # If this is an array of attributes, at least one of the entries should be present
          valid = \
            if attribute.is_a?(Array)
              (attribute - user_params.keys).length < attribute.length
            else
              user_params.key?(attribute)
            end

          unless valid
            missing_attr = attribute.is_a?(Array) ? attribute.join(' or ') : attribute

            render json: user_params.merge({ error: "Missing attribute(s) for saved scenario user: #{missing_attr}" }),
              status: :unprocessable_entity

            return false
          end
        end
      end
    end

    # Format the return values for the users in the given saved scenario
    def users_return_values
      if permitted_params[:saved_scenario_users].present?
        user_ids = permitted_params[:saved_scenario_users].pluck(:user_id)
      end

      saved_scenario_users = @saved_scenario.saved_scenario_users
      saved_scenario_users = saved_scenario_users.where(user_id: user_ids) if user_ids.present?

      saved_scenario_users.map do |su|
        { id: su.id, user_id: su.user_id, user_email: su.user_email, role: User::ROLES[su.role_id] }
      end
    end

    # Create a new SavedScenarioUser record from given user_params
    def new_saved_scenario_user_from(user_params)
      user = User.find(user_params[:user_id]) if user_params[:user_id].present?

      SavedScenarioUser.new(
        saved_scenario: @saved_scenario,
        role_id: User::ROLES.key(user_params.try(:[], :role).try(:to_sym)),
        user_id: user&.id,
        user_email: user&.email || user_params.try(:[], :user_email)
      )
    end

    # Synchronize the user roles between the SavedScenario and its Scenarios in ETEngine
    # by calling the respective *APIScenarioUser service class.
    def synchronize_api_scenario_user(action, saved_scenario_user)
      api_service = "#{action.titleize}APIScenarioUser".constantize

      user_params = {
        user_id: saved_scenario_user.user_id,
        user_email: saved_scenario_user.user_email,
        role: User::ROLES[saved_scenario_user.role_id]
      }

      # Set arguments for the call of the current scenario.
      # Add extra hash with information about the SavedScenario that are needed
      # to send an invitation mail to the invited user if we are about to send a 'create' event.
      if action.downcase == 'create'
        api_service.call(
          engine_client, @saved_scenario.scenario_id, user_params,
          { invite: true, user_name: current_user.name, id: @saved_scenario.id, title: @saved_scenario.title }
        )
      else
        api_service.call(engine_client, @saved_scenario.scenario_id, user_params)
      end

      # Update role for all historic scenarios as well
      @saved_scenario.scenario_id_history.each do |scenario_id|
        api_service.call(engine_client, scenario_id, user_params)
      end
    end
  end
end
