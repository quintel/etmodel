# frozen_string_literal: true

# Recouples the groups to the scenario
class RecoupleAPIScenario
  extend Dry::Initializer
  include Service

  param :http_client
  param :scenario_id
  param :groups

  def call
    ServiceResult.success(
      http_client.post("/api/v3/scenarios/#{scenario_id}/couple", { groups: groups })
    )
  rescue Faraday::ResourceNotFound
    ServiceResult.failure('Scenario not found')
  rescue Faraday::UnprocessableEntityError
    ServiceResult.failure('Scenario cannot be recoupled, possibly due to hard uncoupling')
  rescue Faraday::Error => e
    Sentry.capture_exception(e)
    ServiceResult.failure('Failed to recouple scenario')
  end
end
