# frozen_string_literal: true

# Fetches Mailchimp contact information for the user.
#
# If the request succeeds and the contact exists, a ServiceResult::Success is
# returned with a hash of the contact data. If the contact does not exist, the
# Success contains nil.
#
# See: https://api.mailchimp.com/schema/3.0/Lists/Members/Instance.json
class FetchMailchimpContact < MailchimpService
  def call(user)
    resp = send_request(:get, self.class.remote_id(user.email))
    result_from_response(resp, user, allow_not_found: true)
  end
end
