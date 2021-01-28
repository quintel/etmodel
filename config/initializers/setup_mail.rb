# frozen_string_literal: true

if !Rails.env.development? && !Rails.env.test?
  email_settings = YAML.safe_load(File.open(Rails.root.join('config/email.yml')))

  if email_settings[Rails.env].present?
    ActionMailer::Base.smtp_settings = email_settings[Rails.env].symbolize_keys
    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.perform_deliveries = true
  end
end
