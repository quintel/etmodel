# frozen_string_literal: true

class RecoupleAPIScenario
  include Service

  def initialize(http_client, id, groups = nil)
    @http_client = http_client
    @id = id
    @groups = groups
  end

  def call
    payload = { groups: @groups }
    response = @http_client.post("/api/v3/scenarios/#{@id}/couple", payload)

    if response.success?
      ServiceResult.success
    else
      ServiceResult.failure("Recoupling failed: #{response.body}")
    end
  rescue Faraday::ResourceNotFound
    Rails.logger.error "Scenario not found: #{@id}"
    ServiceResult.failure('Scenario not found')
  rescue Faraday::UnprocessableEntityError
    Rails.logger.error "Recoupling not possible for scenario #{@id}, possibly due to hard uncoupling"
    ServiceResult.failure('Scenario cannot be recoupled, possibly due to hard uncoupling')
  rescue Faraday::Error => e
    Rails.logger.error "Failed to recouple scenario #{@id} with error: #{e.message}"
    Sentry.capture_exception(e)
    ServiceResult.failure('Failed to recouple scenario')
  end
end
