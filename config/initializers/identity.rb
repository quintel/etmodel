# frozen_string_literal: true

Identity.configure do |config|
  config.issuer = Settings.api_url
  config.client_uri = Settings.identity.client_uri
  config.client_id = Settings.identity.client_id
  config.client_secret = Settings.identity.client_secret
  config.scope = 'openid profile email scenarios:read scenarios:write scenarios:delete'
  config.validate_config = ENV['DOCKER_BUILD'] != 'true'

  # Create or update the local user when signing in.
  config.on_sign_in = lambda do |session|
    User.from_identity!(session.user)
  end
end

if Rails.env.development?
  # In development, ETEngine often runs as only a single process. Pre-fetch the JWKS keys from the
  # engine so that the first request to the API does not deadlock.
  require_relative '../../lib/etmodel/engine_token'
  ETModel::EngineToken.jwk_set rescue nil
end