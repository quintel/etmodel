# frozen_string_literal: true

class MyEtmPassthruController < ApplicationController
  # This action sets a cookie to track the last visited page
  # and then redirects the user to the specified destination.
  # The last visited path is either the root page, or the play area
  #
  # Always redirects to my ETM
  def set_cookie_and_redirect
    cookies[:etm_last_visited_page] = {
      value: Current.setting.last_etm_page.presence || root_path,
      domain: :all,
      secure: Rails.env.production?,
      expires: 1.day.from_now
    }

    redirect_to "#{Settings.identity.issuer}/#{params[:page]}", allow_other_host: true
  end
end
