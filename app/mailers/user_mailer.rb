class UserMailer < ActionMailer::Base
  default from: "no-reply@quintel.com"
  
  def support_mail(user, subject, template)
    @user = user
    @unsubscribe_link = "http://www.energietransitiemodel.nl/users/#{user.id}/unsubscribe?h=#{ user.md5_hash }"
    mail(to: user.email, subject: subject, template_name: template)
  end
end
