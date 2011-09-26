class Notifier < ActionMailer::Base

  def comment_mail(comment)
    @comment = comment
    mail( :to => "mark.denheijer@quintel.com,robbert.dol@quintel.com",
          :from => "info@energytransitionmodel.com",
          :subject => "Comment geplaatst bij backcasting")
  end

  def feedback_mail(options)
    @options = options
    mail( :to => "john.kerkhoven@quintel.com,robbert.dol@quintel.com,dennis.schoenmakers@quintel.com",
          :from => options[:email],
          :subject => "Feedback ETM")
  end
  
  def feedback_mail_to_sender(options)
    @options = options
    mail( :to => options[:email],
          :from => "info@energytransitionmodel.com",
          :subject => "Feedback ETM")
  end
end