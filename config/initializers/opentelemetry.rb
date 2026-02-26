# frozen_string_literal: true

require 'opentelemetry/sdk'
require 'opentelemetry/instrumentation/all'
require 'opentelemetry/exporter/otlp'

# OpenTelemetry configuration for distributed tracing
# Sends trace data to Grafana Cloud Tempo for visualization and analysis
# Sentry continues to handle error tracking independently

# Only enable in development for now (can be extended to production later)
if Rails.env.development?
  OpenTelemetry::SDK.configure do |c|
    # Set service name for identification in Grafana
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

    # Configure OTLP exporter to send traces to Grafana Cloud
    c.add_span_processor(
      OpenTelemetry::SDK::Trace::Export::BatchSpanProcessor.new(
        OpenTelemetry::Exporter::OTLP::Exporter.new(
          endpoint: Settings.otel_exporter_otlp_endpoint || 'http://localhost:4318/v1/traces',
          headers: {
            'Authorization' => "Basic #{Settings.grafana_cloud_otlp_auth || ''}"
          },
          ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE # Disable SSL verification in development
        )
      )
    )
  end
end
