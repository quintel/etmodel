# frozen_string_literal: true

# Service to retrieve a scenarios esdl file, updated with user values
#
# Calls the api at the etm_esdl app. The app will fetch the edsl file that is attached to the
# scenario; the file will be updated with ETE scenario values and returned in JSON when successful.
# If the ESDL file cannot be found, the app returns a 404, and when certain aspects of the file are
# not (yet) supported a 422.
class ExportEsdlScenario
  include Service

  def initialize(ete_scenario)
    @ete_scenario = ete_scenario
  end

  def call
    handle_response(send_request)
  end

  private

  def send_request
    HTTParty.public_send(
      :post,
      ete_url,
      { body: { session_id: @ete_scenario, environment: environment } }
    )
  end

  def handle_response(response)
    if response.ok?
      ServiceResult.success(response.parsed_response['energy_system'])
    elsif response.code == 404
      ServiceResult.failure(['This scenario cannot be converted back to ESDL'])
    elsif response.code == 422
      # ESDL file has correct format but could not be created into a scenario
      ServiceResult.failure('Exporting scenario failed: ' + response['message'])
    else
      # Malformed request or internal error of etm-esdl app
      ServiceResult.failure(['Something went wrong'])
    end
  end

  def environment
    Rails.env.production? ? 'pro' : 'beta'
  end

  def ete_url
    Settings.esdl_ete_url + 'export_esdl/'
  end
end
