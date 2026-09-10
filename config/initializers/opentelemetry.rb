# frozen_string_literal: true

# Native OpenTelemetry tracing.
#
# Purpose: emit a client span for every server-side call etmodel makes to
# etengine (through the Faraday client built in the `identity` gem), and
# propagate W3C `traceparent` so etengine's server span nests underneath it.
# The isolated network+TLS latency of the internal-network hop is then
# `client_span - etengine_server_span` per trace.
#
# This runs alongside Sentry (kept for error tracking) and the Beyla sidecar
# (kept for etmodel's inbound HTTP spans). We instrument Faraday *only* — no
# Rack/server span here — so we do not double up on Beyla's inbound spans.
#
# Inert unless OTEL_EXPORTER_OTLP_ENDPOINT is set (wired per environment in the
# ansible group_vars alongside SENTRY_DSN); dev/test stay untouched.
if ENV['OTEL_EXPORTER_OTLP_ENDPOINT'].present?
  # faraday is a transitive dependency (via the identity gem), so it is not
  # guaranteed loaded before initializers. Require it explicitly, otherwise the
  # instrumentation finds no Faraday constant at configure time and never patches.
  require 'faraday'
  require 'opentelemetry/sdk'
  require 'opentelemetry-exporter-otlp'
  require 'opentelemetry/instrumentation/faraday'

  OpenTelemetry::SDK.configure do |c|
    # service.name, service.namespace and deployment.environment come from
    # OTEL_SERVICE_NAME / OTEL_RESOURCE_ATTRIBUTES (set in the container env).
    c.use('OpenTelemetry::Instrumentation::Faraday')
  end
end
