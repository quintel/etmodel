# frozen_string_literal: true

require 'identity/test/controller_helpers'

module EtmAuthHelper
  include Identity::Test::ControllerHelpers

  def login_as(user)
    sign_in(user)
  end
end
