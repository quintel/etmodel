# frozen_string_literal: true

if Settings.sentry_dsn
  Sentry.init do |config|
    # Set release version
    config.release = Settings.release

    config.dsn = Settings.sentry_dsn
    config.enabled_environments = %w[production staging]

    # Use OpenTelemetry for instrumentation instead of Sentry's native instrumentation
    config.instrumenter = :otel

    # Set traces_sample_rate to capture 10% of transactions for tracing
    config.traces_sample_rate = 0.1

    # Set profiles_sample_rate to profile 10% of sampled transactions
    config.profiles_sample_rate = 0.1
  end
end
