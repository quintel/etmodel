# frozen_string_literal: true

if (Rails.env.staging? || Rails.env.production?) && ENV['MAILER_SMTP_SETTINGS'].present?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = JSON.parse(ENV['MAILER_SMTP_SETTINGS']).symbolize_keys
  ActionMailer::Base.default_url_options = { host: ENV['MAILER_HOST'] }
  ActionMailer::Base.asset_host = ENV['MAILER_HOST']
end
