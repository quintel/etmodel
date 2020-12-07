# frozen_string_literal: true

# Only login and redirect. Uses a service that helps with logging in a user
# through OpenIDConnect
class EsdlSuiteController < ApplicationController
  before_action :ensure_esdl_suite_configured
  before_action :generate_nonce

  # Redirects the user to the login page of the ESDL Suite
  def login
    redirect_to esdl_suite_service.auth_uri(session[:nonce])
  end

  # Route where the ESDL Suite redirects the user to after a succesfull login
  # Extracts the users info through the EsdlSuiteService
  def redirect
    @user_info = esdl_suite_service.redirect(params[:code], session[:nonce])

    # Store in session for now
    session[:esdl_user_info] = @user_info
    redirect_to import_esdl_path
  end

  private

  # Set up a new EsdlSuiteService to handle all OpenIDConnect communications
  def esdl_suite_service
    @esdl_suite_service ||= EsdlSuiteService.new(
      APP_CONFIG[:esdl_suite_url], APP_CONFIG[:esdl_suite_client_id],
      APP_CONFIG[:esdl_suite_client_secret], redirect_url
    )
  end

  def ensure_esdl_suite_configured
    redirect_to import_esdl_path unless APP_CONFIG[:esdl_suite_client_id].present? &&
      APP_CONFIG[:esdl_suite_client_secret].present? &&
      APP_CONFIG[:esdl_suite_url].present?
  end

  # TODO: generate a unique value. Nonce is used to validate the request at
  # our side.
  def generate_nonce
    return if session[:nonce]

    session[:nonce] = 'xxx'
  end

  # The url the ESDL Suite should redirect to after a successfull user login
  def redirect_url
    URI.join(root_url, esdl_suite_redirect_path).to_s
  end
end
