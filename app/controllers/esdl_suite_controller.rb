# frozen_string_literal: true

# Only login and redirect. Uses a service that helps with logging in a user
# through OpenIDConnect
class EsdlSuiteController < ApplicationController
  before_action :require_user
  before_action :ensure_esdl_suite_configured

  # Redirects the user to the login page of the ESDL Suite
  def login
    redirect_to esdl_suite_service.auth_uri(new_nonce)
  end

  # Route where the ESDL Suite redirects the user to after a succesfull login
  # Authenticates and creates an EsdlSuiteId for the user through the EsdlSuiteService
  def redirect
    esdl_suite_service.authenticate(params[:code], stored_nonce, current_user)

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

  # Generates a unique value. Nonce is used to validate the request at
  # our side.
  def new_nonce
    session[:esdl_nonce] = SecureRandom.hex(16)
  end

  # Delete nonce after single use
  def stored_nonce
    session.delete(:esdl_nonce)
  end

  # The url the ESDL Suite should redirect to after a successfull user login
  def redirect_url
    URI.join(root_url, esdl_suite_redirect_path).to_s
  end
end
