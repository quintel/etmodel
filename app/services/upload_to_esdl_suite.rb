# frozen_string_literal: true

# Upload an ESDL file to the Mondaine Drive using an EsdlSuiteId
class UploadToEsdlSuite < EsdlSuiteService
  # Uploads a .esdl file to the Mondaine Drive
  #
  # esdl_suite_id - An EsdlSuiteId with which we can communicate with the Drive on the users behalf
  # path          - The path on the Drive to where the desired file should be stored, e.g.
  #                 '/Projects/Mondaine/myfile.esdl'
  # file          - The file that needs to be uploaded in xml format
  #
  # Returns a ServiceResult
  def call(esdl_suite_id, path, file)
    return ServiceResult.failure unless esdl_suite_id.try_viable

    encoded_path = CGI.escape(path).gsub('+', '%20')
    handle_upload_response(HTTParty.put(
      'https://drive.esdl.hesi.energy/store/resource/' + encoded_path,
      headers: headers_for(esdl_suite_id).merge({ 'Content-type' => 'application/xml' }),
      body: file
    ))
  end

  private

  def handle_upload_response(response)
    if response.success?
      ServiceResult.success(response.body)
    else
      ServiceResult.failure(['Something went wrong'])
    end
  end
end
