# frozen_string_literal: true

# Sends feedback messages to a mailbox.
class FeedbackMailer < ActionMailer::Base
  default from: 'mailserver@quintel.com'

  def feedback_message(user, data)
    @user              = user
    @charts            = data[:charts]
    @locale            = data[:locale]
    @saved_scenario_id = data[:saved_scenario_id]
    @scenario_url      = data[:scenario_url]
    @text              = data[:text]
    @user_agent        = data[:user_agent]

    @page = "#{url_options[:host]}#{data[:page]}" if data[:page] && data[:page][0] == '/'

    mail(
      to: Settings.feedback_email,
      reply_to: user&.email || 'no-reply@quintel.com',
      subject: 'ETM Feedback'
    )
  end
end
