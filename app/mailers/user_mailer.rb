class UserMailer < ActionMailer::Base
  default from: "no-reply@quintel.com"

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
