# frozen_string_literal: true

# Destroys a contact on Mailchimp.
#
# This should only be used when deleting a user from the local DB; if you only
# wish to unsubscribe the user, use `DestroyNewsletterSubscription`.
class DestroyMailchimpContact < MailchimpService
  def call(user)
    resp = send_request(:delete, self.class.remote_id(user.email))
    result_from_response(resp, user, allow_not_found: true)
  end
end
