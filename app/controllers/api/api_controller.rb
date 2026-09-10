# frozen_string_literal: true

module API
  # Base class for all API controllers.
  class APIController < ActionController::API
    abstract!

    include Identity::ResourceServer

    rescue_from ActionController::ParameterMissing do |e|
      render json: { errors: [e.message] }, status: :bad_request
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: {
        errors: ["No such #{e.model.underscore.humanize.downcase}: #{e.id}"]
      }, status: :not_found
    end

    # Returns the current user, if a token is set and is valid.
    def current_user
      return nil unless decoded_token

      @current_user ||= User.from_jwt!(decoded_token)
    end

    # Verifies that a token is set and is valid.
    def verify_token!
      decoded_token || render(json: { errors: ['Missing or invalid token'] }, status: :unauthorized)
    end
  end
end
