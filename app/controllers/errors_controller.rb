# frozen_string_literal: true

# Renders 404 and 500 error messages.
class ErrorsController < ApplicationController
  layout false

  def show
    # Valid codes are checked in the router. Sanity check anyway...
    code = params[:code] =~ /\A\d+\Z/ ? params[:code].to_i : 404

    render(
      file: Rails.root.join("public/#{ code }.html"),
      status: code
    )
  end
end
