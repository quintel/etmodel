# frozen_string_literal: true

class RedirectController < ApplicationController

  # This action sets a cookie to track the last visited page
  # and then redirects the user to the specified destination.
  def set_cookie_and_redirect
    cookies[:last_visited_page] = {
      value: params[:return_to] || root_path,
      domain: :all,
      secure: Rails.env.production?,
      expires: 1.day.from_now
    }

    redirect_to params[:destination]
  end
end
