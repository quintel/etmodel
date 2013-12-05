Etm::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Enable threaded mode
  # config.threadsafe!

#  config.action_controller.session = {
#    :session_key => '_etm_production',
#    :secret      => '73916e8ec68237f87e1e9ae492e8eb3de2157da4d3141c74f3918060cba89e8fdd39a145990041ced83ffb5a96212399ff12b853157a4df9a0bdc71833130'
#  }

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = false
  config.action_controller.perform_caching             = true

  # Use a different cache store in production
  config.cache_store = :dalli_store

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host                  = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = false


  # Make Haml faster in production mode
  Haml::Template::options[:ugly] = true

  config.serve_static_assets = false
  config.assets.compress = true
  config.assets.digest = true
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  config.i18n.fallbacks = true

  config.eager_load = true
end
