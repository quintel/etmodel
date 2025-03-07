# frozen_string_literal: true

class CreateSavedScenario
  extend Dry::Initializer
  include Service

  param :http_client
  param :scenario_id
  param :settings, default: proc { {} }

  def call
    return ServiceResult.failure(@errors.join(', ')) if invalid_params.any?

    response = http_client.post('api/v1/saved_scenarios') do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = request_body
    end

    ServiceResult.success(response.body)
  rescue Faraday::UnprocessableEntityError => e
    ServiceResult.failure_from_unprocessable_entity(e)
  rescue Faraday::UnauthorizedError => e
    ServiceResult.failure_from_unprocessable_entity(e)
  end

  private

  def request_body
    {
      saved_scenario: {
        scenario_id: scenario_id,
        version: ETModel::Version::TAG
      }.merge(settings.slice(:title, :area_code, :end_year))
    }.to_json
  end

  # NOTE: should be done with a Dry::Contract
  def invalid_params
    @errors = []
    @errors << 'Title cannot be blank' if settings[:title].blank?

    unless scenario_id.to_i.to_s == scenario_id.to_s
      @errors << 'Scenario ID must be a valid integer'
    end

    @errors
  end
end
