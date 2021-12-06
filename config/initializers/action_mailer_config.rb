# frozen_string_literal: true

if Rails.env.staging? || Rails.env.production?
  # Old Capistrano deployments.
  if ENV['MAILER_SMTP_SETTINGS'].present?
    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.smtp_settings = JSON.parse(ENV['MAILER_SMTP_SETTINGS']).symbolize_keys
    ActionMailer::Base.default_url_options = { host: ENV['MAILER_HOST'] }
    ActionMailer::Base.asset_host = ENV['MAILER_HOST']
  elsif File.file?(Rails.root.join('config/email.yml'))
    # New Docker-based deployments.
    email_settings = YAML.safe_load(File.open(Rails.root.join('config/email.yml')))

    if email_settings[Rails.env].present?
      ActionMailer::Base.smtp_settings = email_settings[Rails.env].symbolize_keys
      ActionMailer::Base.delivery_method = :smtp
      ActionMailer::Base.perform_deliveries = true
    end
  end
end
