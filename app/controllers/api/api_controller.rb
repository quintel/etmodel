# frozen_string_literal: true

module API
  # Base class for all API controllers.
  class APIController < ActionController::API
    abstract!

    rescue_from JWT::DecodeError do |e|
      render json: { errors: [e.message] }, status: :forbidden
    end

    rescue_from ActionController::ParameterMissing do |e|
      render json: { errors: [e.message] }, status: :bad_request
    end

    # Returns the current user, if a token is set and is valid.
    def current_user
      return nil unless token

      @current_user ||= User.from_jwt!(token) if token
    end

    # Verifies that a token is set and is valid. Raises if the token is invalid and is caught by
    # the rescue_from block above.
    def verify_token!
      token || render(json: { errors: ['Missing or invalid token'] }, status: :forbidden)
    end

    # Returns the contents of the current token, if an Authorization header is set.
    def token
      return @token if @token
      return nil if request.authorization.blank?

      request.authorization.to_s.match(/\ABearer (.+)\z/) do |match|
        return @token = ETModel::EngineToken.verify(match[1])
      end
    end
  end
end
