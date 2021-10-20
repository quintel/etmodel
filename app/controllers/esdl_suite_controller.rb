# frozen_string_literal: true

# Only login and redirect. Uses a service that helps with logging in a user
# through OpenIDConnect
class EsdlSuiteController < ApplicationController
  before_action :require_user
  before_action :ensure_esdl_suite_configured
  before_action :require_esdl_suite_id, only: :browse

  # Redirects the user to the login page of the ESDL Suite
  def login
    redirect_to esdl_suite_service.auth_uri(new_nonce)
  end

  # Route where the ESDL Suite redirects the user to after a succesfull login
  # Authenticates and creates an EsdlSuiteId for the user through the EsdlSuiteService
  def redirect
    esdl_suite_service.authenticate(params[:code], stored_nonce, current_user)

    redirect_to previous_esdl_action
  end

  # Browse the Mondaine Drive with an EsdlSuiteId
  # Returns a json containing a list of file/folder nodes that are children
  # of the folder requested in the param 'path'
  def browse
    tree_result = BrowseEsdlSuite.call(
      current_user.esdl_suite_id,
      params[:path]
    )

    render json: tree_result.value and return if tree_result.successful?

    render json: [], status: :not_found
  end

  private

  # Set up a new EsdlSuiteService to handle all OpenIDConnect communications
  def esdl_suite_service
    @esdl_suite_service ||= EsdlSuiteService.setup
  end

  def ensure_esdl_suite_configured
    redirect_to import_esdl_path unless Settings.esdl_suite_client_id.present? &&
      Settings.esdl_suite_client_secret.present? &&
      Settings.esdl_suite_url.present? &&
      Settings.esdl_suite_redirect_url.present?
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

  # If last location of esdl action was not stored, return to root
  def previous_esdl_action
    session[:return_to] or root_path
  end

  def require_esdl_suite_id
    redirect_to previous_esdl_action if current_user.esdl_suite_id.blank?
  end
end
