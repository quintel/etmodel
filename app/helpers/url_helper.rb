module UrlHelper
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
