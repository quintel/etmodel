# frozen_string_literal: true

require 'identity/test/system_helpers'

module RequestHelpers
  include Identity::Test::SystemHelpers

  # Sign in a user using the Identity provider.
  #
  # @param user [User] The user to sign in.
  # @return [Identity::AccessToken] The access token for the user session.
  def sign_in(user)
    token = mock_omniauth_user_sign_in(id: user.id, email: user.email, name: user.name)

    post('/auth/identity')
    follow_redirect!

    token
  end
end
