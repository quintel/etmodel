require File.expand_path(File.dirname(__FILE__)) + '/production'

Etm::Application.configure do
  # Settings specified here will take precedence over those in
  # config/application.rb

  config.action_mailer.default_url_options = {
    host: 'beta-pro.energytransitionmodel.com'
  }
end
