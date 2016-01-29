module UrlHelper
  def et_engine_graph_url
    "#{ APP_CONFIG[:api_url] }/data/#{ Current.setting.api_session_id }/layout"
  end

  def flexibility_urls
    Hash[%i(get set).map do |method|
      [ method,
        "#{ APP_CONFIG[:api_url] }/api/v3/scenarios/#{ Current.setting.api_session_id }/flexibility_order/#{ method }"
      ]
    end]
  end
end
