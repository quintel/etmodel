# frozen_string_literal: true

# Unsubscribes the user from the ETM newsletter.
#
# user - User to be unsubscribed.
#
# Returns a ServiceResult with the response from Mailchimp.
class DestroyNewsletterSubscription < MailchimpService
  def call(user)
    result_from_response(send_request(
      :patch,
      self.class.remote_id(user.email),
      status: 'unsubscribed'
    ), user, allow_not_found: true)
  end
end
