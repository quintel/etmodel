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

# frozen_string_literal: true

# Notifies Quintel of contact being sent
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
    ) do |format|
      format.text { render plain: render_message(:text) }
      format.html { render html: render_message(:html).html_safe }
    end
  end

  private

  def render_message(format)
    case format
    when :text
      <<~TEXT
        Feedback received:
        Name: #{@message.name}
        Email: #{@message.email}
        Message: #{@message.body}

        User Agent: #{@user_agent || 'Unknown'}
        Locale: #{@locale || 'Unknown'}
      TEXT
    when :html
      <<~HTML
        <h1>Feedback received</h1>
        <p><strong>Name:</strong> #{@message.name}</p>
        <p><strong>Email:</strong> #{@message.email}</p>
        <p><strong>Message:</strong></p>
        <pre>#{@message.body}</pre>
        <hr>
        <p><strong>User Agent:</strong> #{@user_agent || 'Unknown'}</p>
        <p><strong>Locale:</strong> #{@locale || 'Unknown'}</p>
      HTML
    end
  end
end
