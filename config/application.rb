require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Etm
  class Application < Rails::Application

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    ## Pseudo-modules
    # I packaged some classes/files separate folders
    # so we need to load them here. This is only for classes
    # that belong together but where it didn't make sense to
    # put them in a module.
    config.autoload_paths += Dir["#{Rails.root}/app/controllers/application_controller"]

    config.active_support.deprecation = :log
    config.time_zone = 'Amsterdam'

    config.secret_token = '73916e8ec68237f87e1e992eae492e8eb3de2157da4d3141c74f3918060cba89e8fdd39a145990041ced83ffb5a96212399ff12b853157a4df9a0bdc71833130'
    config.encoding = "utf-8"

    config.filter_parameters << :password

    config.generators do |g|
      g.template_engine :haml
      g.test_framework  :rspec, :fixture => false
    end

    config.assets.enabled = true
    config.assets.precompile += ['etm.js', 'refreshed.js', 'refreshed.css', 'admin.css', 'ie.css']
    config.assets.css_compressor = :yui
    config.assets.js_compressor = :uglifier
    config.assets.compress = true
  end

  LOCALES_DIRECTORY = "#{Rails.root}/config/locales"
  LOCALES_AVAILABLE = Dir["#{LOCALES_DIRECTORY}/*.{rb,yml}"].collect do |locale_file|
    I18n.load_path << locale_file
    File.basename(File.basename(locale_file, ".rb"), ".yml")
  end
  Date::DATE_FORMATS[:default] = "%d-%m-%Y"
end

ALLOWED_BROWSERS = %w[firefox ie10 ie9 ie8 ie7 chrome safari]
GC_DISABLING_HACK_ENABLED = true
