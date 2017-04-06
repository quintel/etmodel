class Notifier < ActionMailer::Base
  def feedback_mail(options)
    @options = options
    mail( to: "john.kerkhoven@quintel.com,dennis.schoenmakers@quintel.com",
          from: options[:email],
          subject: "Feedback ETM")
  end

  def feedback_mail_to_sender(options)
    @options = options
    mail( to: options[:email],
          from: "info@energytransitionmodel.com",
          subject: "Feedback ETM")
  end
end
