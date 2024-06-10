require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Etm
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    config.time_zone = 'Etc/UTC'
    config.encoding = 'utf-8'

    config.autoload_lib(ignore: %w(tasks templates))

    config.i18n.available_locales = %i[en nl]
    config.i18n.load_path += Dir[Rails.root.join('config','locales','**/*.yml')]

    config.generators do |g|
      g.template_engine :haml
      g.test_framework  :rspec, fixture: false
    end

    # Custom 404 and 500 page
    config.exceptions_app = routes

    # Hopefully fixes Segfaults in sassc: https://github.com/sass/sassc-ruby/issues/197
    config.assets.configure { |env| env.export_concurrent = false }
  end

  Date::DATE_FORMATS[:default] = '%d-%m-%Y'
end
