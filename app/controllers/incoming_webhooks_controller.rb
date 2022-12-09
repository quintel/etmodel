# frozen_string_literal: true

# Handles webhooks originating in other applications.
class IncomingWebhooksController < ApplicationController
  before_action :assert_valid_key, except: :verify

  skip_before_action :verify_authenticity_token

  rescue_from ActionController::ParameterMissing do
    head :bad_request
  end

  # Used as a dummy action for Webhook senders which want to send a GET request
  # verifying that the app is available. Does not verify the key.
  def verify
    head :ok
  end

  private

  def assert_valid_key
    key = Settings.dig(:incoming_webhook_keys, action_name)
    head :forbidden unless key && params[:key] == key
  end
end
