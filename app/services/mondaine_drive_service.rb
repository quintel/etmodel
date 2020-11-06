# frozen_string_literal: true

# Base class for communications with the Mondaine Drive
# Retrieves access tokens for making download, upload
# and browse requests possible
#
# The application config must have a `mondaine_drive_api_url` and
# `mondaine_drive_auth_url` in order to send requests to Mondaine Drive.
class MondaineDriveService
  include Service

  def self.configured?
    APP_CONFIG[:mondaine_drive_api_url].present? &&
      APP_CONFIG[:mondaine_drive_auth_url].present?
  end

  def self.call(*args)
    return ServiceResult.failure(['Mondaine Drive not configured']) unless configured?

    new(
      APP_CONFIG[:mondaine_drive_api_url], APP_CONFIG[:mondaine_drive_auth_url]
    ).call(*args)
  end

  def initialize(api_url, authentication_url)
    @api_url = api_url
    @authentication_url = authentication_url
  end

  def call
    raise NotImplementedError
  end

  # Public: returns an access token. If supplied token is invalid, refreshes the token.
  def validate_token(token)
    return token if token[:expires_at] > Time.current

    refresh_access_token(token).value
  end

  # Public: returns a ServiceResult with the access token in the value
  def get_access_token(username, password)
    handle_authentication_response(send_authentication_request(username, password))
  end

  # Public: returns a ServiceResult with the refreshed access token in the value
  def refresh_access_token(old_token)
    handle_authentication_response(send_refresh_authentication_request(old_token))
  end

  private

  # TODO: add send_api_request and handle_api_reponse methods here to
  # support download, upload and browse later on

  # Private: send a request to the authentication url to retrieve an access token
  def send_authentication_request(username, password)
    data = {
      username: username,
      password: password,
      grant_type: 'password',
      client_id: 'curl',
      scope: 'openid profile email microprofile-jwt user_group_path'
    }
    HTTParty.public_send(:post, @authentication_url, data: data)
  end

  # Private: send a request to the authentication url to refresh an access token
  def send_refresh_authentication_request(old_token)
    data = {
      client_id: 'curl',
      grant_type: 'refresh_token',
      refresh_token: old_token[:refresh_token]
    }
    HTTParty.public_send(:post, @authentication_url, data: data)
  end

  # Private: creates a ServiceResult from the Mondaine Drive response, formatting
  # errors appropriately
  def handle_authentication_response(response)
    # TODO: check for more specific reponse codes
    if response.ok?
      token = response.to_h
      token[:expires_at] = Time.current + token[:expires_in].seconds
      ServiceResult.success(token)
    else
      ServiceResult.failure(format_authentication_error(response))
    end
  end

  def format_authentication_error(response)
    "Mondaine Drive authentication error: #{response[:status]} #{response[:text]}"
  end
end
