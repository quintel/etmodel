# frozen_string_literal: true

module API
  # Base class for all API controllers.
  class APIController < ActionController::API
    abstract!

    rescue_from ETModel::TokenDecoder::DecodeError do |e|
      render json: { errors: [e.message] }, status: :forbidden
    end

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
      return nil unless token

      @current_user ||= User.from_jwt!(token) if token
    end

    # Verifies that a token is set and is valid.
    def verify_token!
      token || render(json: { errors: ['Missing or invalid token'] }, status: :unauthorized)
    end

    # Verifies that the token has the desired scopes.
    def verify_scopes!(required_scopes)
      missing = Array(required_scopes).reject { |scope| token['scopes'].include?(scope) }

      return if missing.empty?

      render(
        json: { errors: ["Missing required scope: #{missing.join(', ')}"] },
        status: :forbidden
      )
    end

    # Returns the contents of the current token, if an Authorization header is set.
    def token
      return @token if @token
      return nil if request.authorization.blank?

      request.authorization.to_s.match(/\ABearer (.+)\z/) do |match|
        return @token = ETModel::TokenDecoder.decode(match[1])
      end
    end

    # TODO: Check forwarding the authentication tokens is functioning correctly
    # Returns the Faraday client which should be used to communicate with ETEngine.
    # This reuses the authentication token from the current request.
    def engine_client
      Faraday.new(url: Settings.ete_url) do |conn|
        unless request.authorization.blank?
          request.authorization.to_s.match(/\ABearer (.+)\z/) do |match|
            conn.request(:authorization, match[1])
          end
        end
      end
    end
  end
end
