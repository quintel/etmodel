# frozen_string_literal: true

if !ENV['DOCKER_BUILD'] && (
    Settings.identity.client_uri.blank? ||
    Settings.identity.client_id.blank? ||
    Settings.identity.client_secret.blank?)
  abort <<~MESSAGE
    ┌─────────────────────────────────────────────────────────────────────────┐
    │           !!!️  NO IDENTITY / AUTHENTICATION CONFIG FOUND !!!️            │
    ├─────────────────────────────────────────────────────────────────────────┤
    │ You're missing the client_id and client_secret used to connect ETModel  │
    │ to ETEngine. Please add these to your config/settings.local.yml file.   │
    │                                                                         │
    │ 1. Visit the ETEngine you wish to connect to. If you're running         │
    │    ETEngine locally, start it with: bundle exec rails server.           │
    │                                                                         │
    │ 2. Sign in to your ETEngine account. If ETEngine is running locally,    │
    │    sign in at http://localhost:3000.                                    │
    │                                                                         │
    │ 3. Scroll down and create a new ETModel or Transition Path application. │
    │                                                                         │
    │ 4. Copy the generated config to ETModel.                                │
    └─────────────────────────────────────────────────────────────────────────┘
  MESSAGE
end

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
