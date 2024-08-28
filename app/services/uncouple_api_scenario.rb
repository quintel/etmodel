# frozen_string_literal: true

class UncoupleAPIScenario
  include Service

  def initialize(http_client, id, groups = nil)
    @http_client = http_client
    @id = id
    @groups = groups
  end

  def call(soft: false)
    Rails.logger.debug "Uncoupling scenario #{@id} with groups: #{@groups.inspect} and soft: #{soft}"

    payload = if soft
                { groups: @groups }
              else
                { force: true }
              end

    response = @http_client.post("/api/v3/scenarios/#{@id}/uncouple", payload)

    if response.success?
      Rails.logger.debug "Uncoupling successful for scenario #{@id}"
      ServiceResult.success
    else
      Rails.logger.error "Uncoupling failed for scenario #{@id} with response: #{response.body}"
      ServiceResult.failure("Uncoupling failed: #{response.body}")
    end
  rescue Faraday::ResourceNotFound
    Rails.logger.error "Scenario not found: #{@id}"
    ServiceResult.failure('Scenario not found')
  rescue Faraday::UnprocessableEntityError
    Rails.logger.warn "Scenario #{@id} cannot be uncoupled, possibly unowned or already uncoupled"
    ServiceResult.success
  rescue Faraday::Error => e
    Rails.logger.error "Failed to uncouple scenario #{@id} with error: #{e.message}"
    Sentry.capture_exception(e)
    ServiceResult.failure('Failed to uncouple scenario')
  end
end
