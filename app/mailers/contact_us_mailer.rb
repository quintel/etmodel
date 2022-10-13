# frozen_string_literal: true

# Notifies quintel of contact being sent
class ContactUsMailer < ActionMailer::Base
  def contact_email(message)
    @message = message

    mail(
      to: 'info@energytransitionmodel.com',
      from: message.email,
      reply_to: message.email,
      subject: 'ETM Feedback'
    )
  end
end
