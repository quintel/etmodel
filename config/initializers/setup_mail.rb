if Rails.env != 'test'
  email_settings = YAML::load(File.open("#{Rails.root.to_s}/config/email.yml"))

  if email_settings[Rails.env].present?
    ActionMailer::Base.smtp_settings = email_settings[Rails.env].symbolize_keys
    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.perform_deliveries = true
  end
end
