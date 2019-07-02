class Notifier < ActionMailer::Base
  def feedback_mail(options)
    @options = options

    mail to: 'info@quintel.com', from: options[:email], subject: 'ETM Feedback'
  end
end
