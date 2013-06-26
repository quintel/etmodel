class UserMailer < ActionMailer::Base
  default from: "info@quintel.com"
  
  def support_mail(user)
    @user = user
    @unsubscribe_link = "http://www.energytransitionmodel.com/users/#{user.id}/unsubscribe?h=#{ user.md5_hash }"
    @url  = "http://www.energytransitionmodel.com/pro"
    mail(from: "info@quintel.com", to: user.email, subject: "Support mail")
  end
end
