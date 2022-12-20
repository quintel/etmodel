# frozen_string_literal: true

# Updates the privacy of an API scenario.
class UpdateAPIScenarioPrivacy
  include Service

  # Updates many scenario IDs.
  def self.call_with_ids(http_client, ids, private:)
    ids.map { |id| call(http_client, id, private:) }
  end

  def initialize(http_client, id, private:)
    @http_client = http_client
    @id = id
    @private = private
  end

  def call
    @http_client.put("/api/v3/scenarios/#{@id}", scenario: { private: @private })
    ServiceResult.success
  rescue Faraday::ResourceNotFound
    ServiceResult.failure('Scenario not found')
  rescue Faraday::UnprocessableEntityError
    # Trying to update an unowned scenario. Ignore.
    ServiceResult.success
  rescue Faraday::Error => e
    Sentry.capture_exception(e)
    ServiceResult.failure('Failed to update scenario')
  end
end
