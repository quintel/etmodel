# frozen_string_literal: true

# Updates a newsletter subscription based on changes made to a User instance.
class UpdateNewsletterSubscription < MailchimpService
  def call(user)
    return ServiceResult.success unless user.email_before_last_save

    result_from_response(send_request(
      :patch,
      self.class.remote_id(user.email_before_last_save),
      email_address: user.email
    ), user)
  end
end
