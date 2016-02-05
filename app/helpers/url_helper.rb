module UrlHelper
  def et_engine_graph_url
    "#{ APP_CONFIG[:api_url] }/data/#{ Current.setting.api_session_id }/layout"
  end
end
