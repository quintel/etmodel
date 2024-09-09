# frozen_string_literal: true

# Uncouple either groups, or with force
class UncoupleAPIScenario
  extend Dry::Initializer
  include Service

  param :http_client
  param :scenario_id
  param :groups, default: proc { [] }
  param :soft, default: proc { true }

  def call
    payload = soft ? { groups: groups } : { force: true }

    ServiceResult.success(
      http_client.post("/api/v3/scenarios/#{scenario_id}/uncouple", payload).body
    )
  rescue Faraday::ResourceNotFound
    ServiceResult.failure('Scenario not found')
  rescue Faraday::UnprocessableEntityError
    ServiceResult.failure_from_unprocessable_entity(e)
  rescue Faraday::Error => e
    Sentry.capture_exception(e)
    ServiceResult.failure('Failed to uncouple scenario')
  end
end
