# frozen_string_literal: true

# Service that calls the api at the etm_esdl app. The app will create an ETE scenario
# based on the specified edsl file when successful, and return the scenario_id in the
# response. If the ESDL file cannot be parsed, the app returns a 404
class CreateEsdlScenario
  include Service

  def initialize(esdl_file)
    @esdl_file = esdl_file.read
  end

  def call
    handle_response(send_request)
  rescue EOFError
    ServiceResult.failure(['File cannot be read'])
  end

  private

  def send_request
    HTTParty.public_send(
      :post,
      api_url,
      { body: { energysystem: @esdl_file, environment: environment } }
    )
  end

  def handle_response(response)
    if response.ok?
      ServiceResult.success(response)
    elsif response.code == 404
      # TODO: add better error handling to esdl app
      ServiceResult.failure(['This ESDL file cannot be converted into a scenario'])
    else
      # Malformed request
      ServiceResult.failure(['Something went wrong'])
    end
  end

  def environment
    return 'pro' if Rails.env == 'production'

    'beta'
  end

  def api_url
    APP_CONFIG[:esdl_api_url]
  end
end
