# frozen_string_literal: true

# Browse the file/folder tree of the Mondaine Drive with an EsdlSuiteId
class BrowseEsdlSuite < EsdlSuiteService
  # Public: Gets the child nodes (files and directories) for a directory in the Mondaine Drive
  #
  # esdl_suite_id - An EsdlSuiteId with which we can communicate with the Drive on the users behalf
  # path          - The path on the Drive to the directory, e.g. 'Projects/Mondaine/'. The default
  #                 path is the root of the Mondaine Drive '/'
  #
  # Returns a ServiceResult
  def call(esdl_suite_id, path = '/')
    return ServiceResult.failure unless esdl_suite_id.fresh?

    query = { 'operation' => 'get_node', 'id' => path }
    handle_tree_response(HTTParty.get(
      'https://drive.esdl.hesi.energy/store/browse',
      query: query,
      headers: headers_for(esdl_suite_id),
      format: :json
    ))
  end

  private

  def handle_tree_response(response)
    if response.success?
      ServiceResult.success(response.parsed_response)
    else
      ServiceResult.failure('Something went wrong')
    end
  end
end
