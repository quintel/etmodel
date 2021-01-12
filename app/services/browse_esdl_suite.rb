# frozen_string_literal: true

# Browse the file/folder tree of the Mondaine Drive with an EsdlSuiteId
class BrowseEsdlSuite < EsdlSuiteService
  # Gets the browse-tree for a path for an esdl_suite_id,
  # The default path is the root of the Mondaine Drive '/'
  def call(esdl_suite_id, _nonce, path = '/')
    return ServiceResult.failure unless esdl_suite_id.fresh?

    # TODO: add nonce
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
