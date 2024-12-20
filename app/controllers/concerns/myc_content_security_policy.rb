# frozen_string_literal: true

# Provides access control headers permitting access from the multi-year charts application.
module MycContentSecurityPolicy
  # Internal: For requests originating in the "multi-year charts" application, we must loading the
  # input elements from the same domain as the application.
  def myc_content_security_policy
    url = Settings.collections_url

    return unless url

    response.set_header('Access-Control-Allow-Origin', url)
    response.set_header('Access-Control-Allow-Methods', 'GET')
    response.set_header('Access-Control-Allow-Headers', 'Accept, Accept-Language, Content-Type')
  end
end
