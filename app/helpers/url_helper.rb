module UrlHelper
  def et_engine_graph_url
    "#{ APP_CONFIG[:api_url] }/data/:id/layout"
  end

  def terms_of_service_url
    "//#{domain}/terms"
  end

  def privacy_url
    "//#{domain}/privacy"
  end

  def contact_url
    "//#{domain}/contact"
  end
end
