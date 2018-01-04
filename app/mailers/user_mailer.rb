class UserMailer < ActionMailer::Base
  default from: "no-reply@quintel.com"

  def support_mail(user, subject, template)
    @user = user
    @unsubscribe_link = "http://www.energietransitiemodel.nl/users/#{user.id}/unsubscribe?h=#{ user.md5_hash }"
    mail(to: user.email, subject: subject, template_name: template)
  end

  def password_reset_instructions(user)
    @user = user

    I18n.with_locale do
      mail(
        to: user.email,
        subject: I18n.t('user.forgot_password.mail.subject')
      )
    end
  end
end
