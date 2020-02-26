# frozen_string_literal: true

# Subscribes the user to the ETM newsletter.
#
# Returns a ServiceResult with the response from Mailchimp.
class CreateNewsletterSubscription < MailchimpService
  # Public: Signs the user up to the mailing list. Does nothing if they are
  # already subscribed or pending e-mail opt-in.
  def call(user)
    fetch_result = FetchMailchimpContact.new(@api_key, @list_url).call(user)

    if fetch_result.successful?
      contact = fetch_result.value

      if contact && !%w[pending subscribed].include?(contact['status'])
        update_contact(user, contact)
      elsif !contact
        create_contact(user)
      else
        # User is already subscribed.
        ServiceResult.success(contact)
      end
    else
      fetch_result
    end
  end

  private

  def create_contact(user)
    result_from_response(send_request(
      :post,
      '',
      email_address: user.email,
      status: 'pending'
    ), user)
  end

  def update_contact(user, contact)
    result_from_response(
      send_request(:patch, contact['id'], status: 'pending'),
      user
    )
  end
end
