# frozen_string_literal: true

CreateSavedScenario = lambda do |http_client, scenario_id, user, settings = {}|
  request_body = { scenario_id: scenario_id }.merge(settings.slice(:title, :description, :area_code, :end_year)).to_json

  response = http_client.post('api/v1/saved_scenarios') do |req|
    req.headers['Content-Type'] = 'application/json'
    req.body = request_body
  end

  return ServiceResult.failure(['Failed to save scenario'], nil) unless response.success?

  ServiceResult.success(response.body)
end
