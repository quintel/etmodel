module UrlHelper
  def et_engine_graph_url
    "#{ APP_CONFIG[:api_url] }/data/:id/layout"
  end
end
