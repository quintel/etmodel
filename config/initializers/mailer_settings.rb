# simple configuration for mailtrap
if Rails.env.development?
  ActionMailer::Base.smtp_settings = {
    :address => 'localhost',
    :port    => 2525
  }
end