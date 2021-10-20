# frozen_string_literal: true

if Settings.sentry_dsn
  Raven.configure do |config|
    config.dsn = Settings.sentry_dsn
    config.environments = %w[production staging]
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  end
end
