# frozen_string_literal: true

# Notifies quintel of contact being sent
class ContactUsMailer < ActionMailer::Base
  def contact_email(message, locale: nil, user_agent: nil)
    @message = message
    @locale = locale
    @user_agent = user_agent

    mail(
      to: Settings.feedback_email,
      from: Settings.feedback_email,
      reply_to: message.email,
      subject: 'ETM Feedback'
    )
  end
end
