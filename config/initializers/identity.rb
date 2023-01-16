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
  config.scope = 'openid profile email roles scenarios:read scenarios:write scenarios:delete'
  config.validate_config = ENV['DOCKER_BUILD'] != 'true'

  # Create or update the local user when signing in.
  config.on_sign_in = lambda do |session|
    User.from_identity!(session.user)
  end

  # We've had cases where browsers make multiple simultaneous requests to the ETM; presumably a
  # browser restoring pages removed from memory. If the access token has expired, this causes the
  # second request to fail due to the refresh token having expired when the first refreshed the
  # access token.
  #
  # 1. Request one starts
  # 2. Request two starts
  # 3. Request one refreshes the access token
  # 4. Request two tries to refresh the token, but the refresh token has expired in (3)
  # 5. Request one completes.
  # 6. Request two fails and signs the user out.
  #
  # To prevent this, if refreshing the token results in an invalid grant error, we
  # wait a short period and attempt to reload the session from the database.
  config.on_invalid_grant = lambda do |controller, exception|
    id_session_key = Identity::ControllerHelpers::IDENTITY_SESSION_KEY

    sleep(1)

    # rubocop:disable Rails/DynamicFindBy
    db_session = controller.session.id &&
      ActiveRecord::SessionStore::Session.find_by_session_id(controller.session.id.private_id)
    # rubocop:enable Rails/DynamicFindBy

    expires_at = db_session&.data&.dig(id_session_key, :access_token, :expires_at)
    token      = db_session&.data&.dig(id_session_key, :access_token, :token)

    if token && expires_at && expires_at > Time.now.to_i
      controller.session[id_session_key] = db_session.data[id_session_key]
      Identity::Session.load(db_session.data[id_session_key])
    else
      controller.reset_session
      Sentry.capture_exception(exception)
      nil
    end
  end
end

if Rails.env.development?
  # In development, ETEngine often runs as only a single process. Pre-fetch the JWKS keys from the
  # engine so that the first request to the API does not deadlock.
  require_relative '../../lib/etmodel/engine_token'

  begin
    ETModel::EngineToken.jwk_set
  rescue StandardError => e
    warn("Couldn't pre-fetch ETEngine public key: #{e.message}")
  end
end
