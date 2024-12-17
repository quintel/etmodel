# frozen_string_literal: true

if Settings.sentry_dsn
  Sentry.init do |config|
    # Set release version
    config.release = 'stable.01'

    config.dsn = Settings.sentry_dsn
    config.enabled_environments = %w[production staging]
  end
end
