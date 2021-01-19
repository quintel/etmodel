# frozen_string_literal: true

# Fetch an ESDL file from the Mondaine Drive using an EsdlSuiteId
class FetchFromEsdlSuite < EsdlSuiteService
  # Fetches a .esdl file from the Mondaine Drive
  #
  # esdl_suite_id - An EsdlSuiteId with which we can communicate with the Drive on the users behalf
  # path          - The path on the Drive to where the desired file is stored, e.g.
  #                 '/Projects/Mondaine/myfile.esdl'
  #
  # Returns a ServiceResult
  def call(esdl_suite_id, path)
    return ServiceResult.failure unless esdl_suite_id.try_viable

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
