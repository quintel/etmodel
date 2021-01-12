# frozen_string_literal: true

# Fetch an .esdl file from the Mondaine Drive with an EsdlSuiteId
class FetchFromEsdlSuite < EsdlSuiteService
  # Fetch a .esdl file from the Mondaine Drive with an esdl_suite_id
  def call(esdl_suite_id, path)
    return ServiceResult.failure unless esdl_suite_id.fresh?

    encoded_path = CGI.escape(path).gsub('+', '%20')
    handle_fetch_response(HTTParty.get(
      'https://drive.esdl.hesi.energy/store/resource/' + encoded_path,
      headers: headers_for(esdl_suite_id)
    ))
  end

  private

  def handle_fetch_response(response)
    if response.success?
      ServiceResult.success(response.body)
    elsif response.code == '404'
      ServiceResult.failure(['File could not be found on the Mondaine Drive'])
    else
      ServiceResult.failure(['Something went wrong'])
    end
  end
end
