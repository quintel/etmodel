require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'active_resource'

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
    config.autoload_paths += Dir["#{Rails.root}/lib"]

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
    config.assets.precompile += ['backcasting.js']

    # Compile images in vendor/assets/images
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)

    config.assets.css_compressor = :yui
    config.assets.js_compressor = :uglifier
    config.assets.compress = true

    #custom 404 and 500 page
    config.exceptions_app = self.routes

    #Needed for i18n-js to work
    config.assets.initialize_on_precompile = true

  end

  Date::DATE_FORMATS[:default] = "%d-%m-%Y"
end
