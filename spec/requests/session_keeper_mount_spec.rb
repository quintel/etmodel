# frozen_string_literal: true

require 'rails_helper'

# The session keeper used to be started by AppView, which only exists on the scenario and report
# pages. Everywhere else the shared session expired with nothing to renew or recover it, and the
# user was signed out on their next click. It is mounted from the layout now — this asserts it
# reaches a page that has no AppView.
RSpec.describe 'Shared session keeper', type: :request do
  it 'is started on a page that has no AppView' do
    VCR.use_cassette('content_pages/development_en') do
      get '/development', params: { locale: :en }
      follow_redirect! if response.redirect?

      expect(response.body)
        .to match(%r{import \{ startSessionKeeper \} from "/assets/identity/session_keeper[^"]*\.js"})
      expect(response.body).to include("startSessionKeeper({")
      expect(response.body).to include("idpUrl: \"#{Settings.identity.issuer}\"")
      expect(response.body)
        .to include("expCookieName: \"#{Identity.config.session_exp_cookie_name}\"")
    end
  end
end
