# frozen_string_literal: true

require 'opentelemetry/sdk'
require 'opentelemetry/instrumentation/all'
require 'sentry-ruby'

# OpenTelemetry configuration for distributed tracing
# Sends trace data to Sentry for visualization and analysis
# Integrates with Sentry's performance monitoring

# Only enable in production and staging environments
if Rails.env.production? || Rails.env.staging?
  OpenTelemetry::SDK.configure do |c|
    # Set service name for identification in Sentry
    c.service_name = 'etmodel'

    # Add resource attributes for better trace context
    c.resource = OpenTelemetry::SDK::Resources::Resource.create(
      'service.name' => 'etmodel',
      'service.version' => Settings.release&.to_s || 'unknown',
      'deployment.environment' => Rails.env.to_s
    )

    # Auto-instrument Rails, HTTP clients, database, Redis, etc.
    # This provides automatic span creation for:
    # - Rails controllers, views, and Active Record queries
    # - HTTP requests via Net::HTTP, HTTParty
    # - Database queries
    # - ActiveSupport::Notifications events
    c.use_all

    # Send spans to Sentry for performance monitoring
    c.add_span_processor(
      OpenTelemetry::SDK::Trace::Export::BatchSpanProcessor.new(
        Sentry::OpenTelemetry::SpanProcessor.instance
      )
    )
  end

  # Configure Sentry propagation to maintain trace context across services
  OpenTelemetry.propagation = Sentry::OpenTelemetry::Propagator.new
end
