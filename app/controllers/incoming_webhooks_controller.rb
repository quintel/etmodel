# frozen_string_literal: true

# Handles webhooks originating in other applications.
class IncomingWebhooksController < ApplicationController
  before_action :assert_valid_key

  rescue_from ActionController::ParameterMissing do
    head :bad_request
  end

  # Handles webhooks requests from Mailchimp. Keeps user subscription state
  # in sync.
  #
  # POST /incoming_webhooks/mailchimp/{key}
  def mailchimp
    type = params.require(:type)
    data = params.require(:data).permit(:email, :old_email)

    # "upmail" event has :old_email key instead of :email.
    user = User.where(email: data[:old_email] || data[:email])

    # The event type is one of:
    #
    # * subscribe   - User is subscribing.
    # * unsubscribe - User is unsubscribing.
    # * cleaned     - E-mails have bounced too many times; consider them
    #                 unsubscribed.
    # * upemail     - User has changed their e-mail on Mailchimp. It no longer
    #                 matches what we have in the DB. Consider them
    #                 unsubscribed.
    user&.update(allow_news: type == 'subscribe')

    head :no_content
  end

  private

  def assert_valid_key
    key = (APP_CONFIG[:incoming_webhook_keys] || {})[action_name]
    head :forbidden unless key && params[:key] == key
  end
end
