# frozen_string_literal: true

if Settings.sentry_dsn
  Sentry.init do |config|
    config.dsn = Settings.sentry_dsn
    config.enabled_environments = %w[production staging]
  end
end
