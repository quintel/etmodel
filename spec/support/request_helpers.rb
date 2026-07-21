# frozen_string_literal: true

require 'identity/test/system_helpers'

module RequestHelpers
  include Identity::Test::SystemHelpers

  # Signs a user in the way MyETM does: by placing a valid shared session cookie in the jar. There
  # is no in-app sign-in flow to drive — ETModel never runs an OAuth exchange.
  #
  # @param user [User] The user to sign in.
  # @return [String] The raw session JWT, for specs that need to assert on it.
  def sign_in(user)
    token = mock_identity_user_sign_in(id: user.id, email: user.email, name: user.name)
    cookies[Identity.config.session_cookie_name] = token

    token
  end
end
