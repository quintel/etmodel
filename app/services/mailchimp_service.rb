# frozen_string_literal: true

# Base class for implementing services which interact with a Mailchimp list.
#
# The application config must have a `mailchimp_api_key` and
# `mailchimp_list_url` in order to send requests to Mailchimp.
class MailchimpService
  include Service

  # Internal: Returns if the application has Mailchimp configured.
  def self.configured?
    Settings.mailchimp_api_key.present? &&
      Settings.mailchimp_list_url.present?
  end

  # Public: Runs the service using the Mailchimp credentials stored in the
  # application config.
  def self.call(*args)
    unless configured?
      return ServiceResult.failure(['Mailchimp not configured'])
    end

    new(
      Settings.mailchimp_api_key,
      Settings.mailchimp_list_url
    ).call(*args)
  end

  # Public: Returns the ID which will be used by Mailchimp to represent the
  # email-address.
  def self.remote_id(email)
    Digest::MD5.hexdigest(email.to_s.downcase)
  end

  # Public: Creates a MailchimpService with the api key and list ID.
  def initialize(api_key, list_url)
    @api_key = api_key
    @list_url = list_url
  end

  # Public: Runs the service.
  def call(*)
    raise NotImplementedError
  end

  private

  # Sends a request to Mailchimp, returning the response data.
  def send_request(method, uri = '', data = nil)
    opts = { basic_auth: { username: 'none', password: @api_key } }
    opts[:body] = data.to_json if data

    HTTParty.public_send(method, "#{@list_url}/members/#{uri}", opts)
  end

  # Takes a response from Mailchimp and creates a ServiceResult, formatting
  # errors as appropriate including notifying Sentry.
  def result_from_response(response, user, allow_not_found: false)
    if response.ok?
      ServiceResult.success(response.to_h)
    elsif response.code == 404 && allow_not_found
      ServiceResult.success(nil)
    else
      notify_sentry(response, user)
      ServiceResult.failure(format_mailchimp_error(response))
    end
  end

  def notify_sentry(response, user)
    Raven.capture_message(
      format_mailchimp_error(response),
      extra: {
        body: JSON.parse(response.request.raw_body),
        service: self.class.name
      },
      user: { id: user.id, email: user.email }
    )
  end

  def format_mailchimp_error(response)
    if response.respond_to?(:to_h)
      data = response.to_h

      "Mailchimp error: #{data['status']} #{data['title']}: " \
      "#{data['detail']}"
    else
      "Mailchimp error: #{response.inspect}"
    end
  end
end
