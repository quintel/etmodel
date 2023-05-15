# frozen_string_literal: true

# Updates the privacy of an API scenario.
class UncoupleAPIScenario
  include Service

  def initialize(http_client, id)
    @http_client = http_client
    @id = id
  end

  def call
    @http_client.put("/api/v3/scenarios/#{@id}", coupling: false)
    ServiceResult.success
  rescue Faraday::ResourceNotFound
    ServiceResult.failure('Scenario not found')
  rescue Faraday::UnprocessableEntityError
    # Trying to update an unowned scenario. Ignore.
    ServiceResult.success
  rescue Faraday::Error => e
    Sentry.capture_exception(e)
    ServiceResult.failure('Failed to uncouple scenario')
  end
end
